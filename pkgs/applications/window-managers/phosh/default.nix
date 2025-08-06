{
  lib,
  stdenv,
  fetchurl,
  directoryListingUpdater,
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
  gtk3,
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
  gobject-introspection,
  appstream,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "phosh";
  version = "0.48.0";

  src = fetchurl {
    # Release tarball which includes subprojects gvc and libcall-ui
    url = with finalAttrs; "https://sources.phosh.mobi/releases/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-GZKxIQgEudCabSC40UqbXgrwjPjdz8X+aoyXNdFzL20=";
  };

  nativeBuildInputs = [
    libadwaita.dev
    meson
    ninja
    pkg-config
    python3
    wayland-scanner
    wrapGAppsHook4
    gobject-introspection
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
    glib.dev
    modemmanager
    gcr
    networkmanager
    polkit
    gmobile
    gnome-bluetooth
    gnome-control-center
    gnome-desktop
    gnome-session
    gtk4.dev
    gtk3.dev
    pam
    systemd
    upower
    wayland
    feedbackd
    appstream
  ];

  patches = [
    # https://gitlab.gnome.org/World/Phosh/phosh/-/merge_requests/1742
    ./0001-plugins-scaling-quick-setting-specify-missing-depend.patch
  ];

  nativeCheckInputs = [
    dbus
    xvfb-run
  ];

  # Temporarily disabled - Test is broken (SIGABRT)
  doCheck = false;

  mesonFlags = [
    "-Dcompositor=${phoc}/bin/phoc"
    # Save some time building if tests are disabled
    "-Dtests=${lib.boolToString finalAttrs.finalPackage.doCheck}"
    # We need this for phrog
    "-Dbindings-lib=true"
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
    updateScript = directoryListingUpdater { };
  };

  meta = with lib; {
    description = "Pure Wayland shell prototype for GNOME on mobile devices";
    homepage = "https://gitlab.gnome.org/World/Phosh/phosh";
    changelog = "https://gitlab.gnome.org/World/Phosh/phosh/-/blob/v${finalAttrs.version}/debian/changelog";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      masipcat
      zhaofengli
    ];
    platforms = platforms.linux;
    mainProgram = "phosh-session";
  };
})
