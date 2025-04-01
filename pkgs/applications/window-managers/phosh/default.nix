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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "phosh";
  version = "0.41.1";

  src = fetchurl {
    # Release tarball which includes subprojects gvc and libcall-ui
    url = with finalAttrs; "https://sources.phosh.mobi/releases/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-Oc6Dltjj+2D3LWZz1eYArqEKEJYYqJPSrScEkxyNhX0=";
  };

  nativeBuildInputs = [
    libadwaita
    meson
    ninja
    pkg-config
    python3
    wayland-scanner
    wrapGAppsHook4
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
    glib
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
