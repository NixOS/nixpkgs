{
  lib,
  stdenv,
  fetchFromCodeberg,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  glib,
  wrapGAppsHook4,
  xvfb-run,
  dbus,
  fontconfig,
  hicolor-icon-theme,
  adwaita-icon-theme,
  gtk4,
  gtk4-layer-shell,
  guile,
  wayland,
  wayland-protocols,
  wlr-protocols,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lambdock";
  version = "0.7.5";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "jjba23";
    repo = "lambdock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C+t8rbv/2sfAyO0cLWi+ydWBNZhilFPERkZhwoe0mUo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    glib
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtk4-layer-shell
    guile
    wayland
    wayland-protocols
    wlr-protocols
  ];

  doCheck = true;

  nativeCheckInputs = [
    xvfb-run
    dbus
    fontconfig
    hicolor-icon-theme
    adwaita-icon-theme
  ];

  checkPhase = ''
    runHook preCheck

    # GTK / X11 test environment configuration
    export HOME=$TMPDIR
    export XDG_RUNTIME_DIR=$TMPDIR
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
    export XDG_DATA_DIRS=${hicolor-icon-theme}/share:${adwaita-icon-theme}/share

    # Disable accessibility bus queries and force GTK to use X11 under Xvfb
    export GTK_A11Y=none
    export GDK_BACKEND=x11

    # Start DBus session bus
    dbus-daemon --config-file=${dbus}/share/dbus-1/session.conf --fork --print-address 5 5>dbus_address
    export DBUS_SESSION_BUS_ADDRESS=$(cat dbus_address)

    # Run tests on virtual display
    xvfb-run -s "-screen 0 1024x768x24" meson test --print-errorlogs

    runHook postCheck
  '';

  meta = with lib; {
    description = "Wayland desktop dock customizable with GNU Guile Scheme";
    homepage = "https://codeberg.org/jjba23/lambdock";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "lambdock";
  };
})
