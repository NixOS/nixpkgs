{
  lib,
  stdenv,
  fetchFromGitLab,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  python3,
  wayland-scanner,
  wrapGAppsHook4,
  libadwaita,
  libhandy,
  libxkbcommon,
  libgudev,
  callaudiod,
  pulseaudio,
  evince,
  glib,
  modemmanager,
  gtk4,
  gnome-bluetooth,
  gnome-control-center,
  gnome-desktop,
  gnome-session,
  gnome-shell,
  gcr,
  pam,
  systemd,
  upower,
  wayland,
  dbus,
  xvfb-run,
  phoc,
  feedbackd,
  networkmanager,
  polkit,
  libsecret,
  evolution-data-server,
  nixosTests,
  gmobile,
  appstream,
  qrcodegen,
  gobject-introspection,
  docutils,
  gi-docgen,
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
    # Workaround for https://github.com/NixOS/nixpkgs/issues/485701
    forceFetchGit = true;
  };

  # Derived from subprojects/gvc.wrap
  gvc = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libgnome-volume-control";
    rev = "d2442f455844e5292cb4a74ffc66ecc8d7595a9f";
    hash = "sha256-10n441b7m/mvQRdrmEsxGxqjKUWzjGvnzJy256NZN5s=";
    # Workaround for https://github.com/NixOS/nixpkgs/issues/485701
    forceFetchGit = true;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "phosh";
  version = "0.54.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = "phosh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gByZRyUe17JY5imgtRdubJl1VH1JxlzmDQkHOtEIvj8=";
    # Workaround for https://github.com/NixOS/nixpkgs/issues/485701
    forceFetchGit = true;
  };

  nativeBuildInputs = [
    libadwaita
    meson
    ninja
    pkg-config
    python3
    wayland-scanner
    wrapGAppsHook4
    docutils
    gi-docgen
  ];

  buildInputs = [
    evince
    phoc
    libhandy
    libsecret
    libxkbcommon
    libgudev
    callaudiod
    evolution-data-server
    pulseaudio
    modemmanager
    gcr
    networkmanager
    polkit
    gmobile
    gnome-bluetooth
    gnome-control-center
    gnome-desktop
    gnome-session
    gtk4
    pam
    systemd
    upower
    wayland
    feedbackd
    appstream
    qrcodegen
    gobject-introspection
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
