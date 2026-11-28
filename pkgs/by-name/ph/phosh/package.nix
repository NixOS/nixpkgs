{
  appstream,
  callaudiod,
  dbus,
  dconf,
  docutils,
  evince,
  evolution-data-server,
  feedbackd,
  fetchFromGitLab,
  gcr_3,
  gi-docgen,
  glib,
  gmobile,
  gnome-bluetooth,
  gnome-control-center,
  gnome-desktop,
  gnome-session,
  gnome-shell,
  gobject-introspection,
  gtk4,
  lib,
  libadwaita,
  libgudev,
  libhandy,
  libsecret,
  libxkbcommon,
  meson,
  modemmanager,
  networkmanager,
  ninja,
  nix-update-script,
  nixosTests,
  pam,
  phoc,
  pipewire,
  pkg-config,
  polkit,
  pulseaudio,
  python3,
  qrcodegen,
  stdenv,
  systemdLibs,
  upower,
  wayland,
  wayland-scanner,
  wrapGAppsHook4,
  xvfb-run,
}:

let
  # Derived from subprojects/libcall-ui.wrap
  libcall-ui = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = "libcall-ui";
    tag = "v0.1.5";
    hash = "sha256-4lSTwSRZditK51N/4s3tmIOgffe5+WyKxVq2IGqWRn4=";
  };

  # Derived from subprojects/gvc.wrap
  gvc = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libgnome-volume-control";
    rev = "0a4eda0cdc2deb352bebc70ec697c42af46094e4";
    hash = "sha256-4s9S6m/rcroR38FSnLeWKZhnym4KROfibgRCjpGMKpY=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "phosh";
  version = "0.59.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = "phosh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cxnldwp+BtT9i57Lfjvd83i2xsy69/UlQa4o5uYfRWg=";
  };

  nativeBuildInputs = [
    docutils
    gi-docgen
    libadwaita
    meson
    ninja
    pkg-config
    python3
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    appstream
    callaudiod
    dconf
    evince
    evolution-data-server
    feedbackd
    gcr_3
    gmobile
    gnome-bluetooth
    gnome-control-center
    gnome-desktop
    gnome-session
    gobject-introspection
    gtk4
    libgudev
    libhandy
    libsecret
    libxkbcommon
    modemmanager
    networkmanager
    pam
    phoc
    pipewire
    polkit
    pulseaudio
    qrcodegen
    systemdLibs
    upower
    wayland
  ];

  nativeCheckInputs = [
    dbus
    xvfb-run
  ];

  # Temporarily disabled - Test is broken (SIGABRT)
  doCheck = false;

  postPatch = ''
    ln -s ${libcall-ui} subprojects/libcall-ui
    ln -s ${gvc} subprojects/gvc
  '';

  mesonFlags = [
    "-Dcompositor=${phoc}/bin/phoc"
    # Save some time building if tests are disabled
    "-Dtests=${lib.boolToString finalAttrs.finalPackage.doCheck}"
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0/"
    "-Dsearchd=true"
    "-Dbindings-lib=true"
    "-Dgtk_doc=true"
    "-Dman=true"
  ];

  checkPhase = ''
    runHook preCheck
    export NO_AT_BRIDGE=1
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test --print-errorlogs
    runHook postCheck
  '';

  # Depends on GSettings schemas in gnome-shell
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${glib.getSchemaDataDirPath gnome-shell}"
      --set GNOME_SESSION "${gnome-session}/bin/gnome-session"
    )
  '';

  passthru = {
    providedSessions = [ "phosh" ];
    tests.phosh = nixosTests.phosh;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Pure Wayland shell for mobile devices";
    homepage = "https://gitlab.gnome.org/World/Phosh/phosh";
    changelog = "https://gitlab.gnome.org/World/Phosh/phosh/-/blob/v${finalAttrs.version}/debian/changelog";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      zhaofengli
      armelclo
    ];
    platforms = lib.platforms.linux;
    mainProgram = "phosh-session";
  };
})
