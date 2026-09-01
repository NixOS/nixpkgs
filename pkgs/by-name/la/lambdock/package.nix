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
  gtk4,
  gtk4-layer-shell,
  guile,
  wayland,
  wayland-protocols,
  wlr-protocols,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lambdock";
  version = "0.6.7";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "jjba23";
    repo = "lambdock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0Ca2twkV6lKdqlw5jp8/bzE5lBoGhR8zaECRRg2wWrY=";
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
  ];

  checkPhase = ''
    runHook preCheck

    # GTK / X11 test environment configuration
    export HOME=$TMPDIR
    export XDG_RUNTIME_DIR=$TMPDIR
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf

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
