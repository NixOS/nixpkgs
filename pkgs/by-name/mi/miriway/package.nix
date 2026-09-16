{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  nixosTests,
  bash,
  boost,
  cmake,
  dbus,
  inotify-tools,
  pkg-config,
  mir,
  libxkbcommon,
  swaybg,
  systemd,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "miriway";
  version = "26.08.1";

  src = fetchFromGitHub {
    owner = "Miriway";
    repo = "Miriway";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VnZuiTSeq/3TwHhoxcYSd36I/KI3MrGdKE1Gz4nmbjU=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'DESTINATION /usr/lib/systemd' 'DESTINATION ''${CMAKE_INSTALL_LIBDIR}/systemd'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    bash
    boost
    dbus
    mir
    libxkbcommon
    wayland # wayland-server.pc, for mirwayland.pc
  ];

  postInstall = ''
    substituteInPlace $out/bin/miriway-background \
      --replace-fail 'exec swaybg' 'exec ${lib.getExe swaybg}'

    substituteInPlace $out/bin/miriway-run \
      --replace-fail 'inotifywait -qq' '${lib.getExe' inotify-tools "inotifywait"} -qq'

    substituteInPlace $out/libexec/miriway-session-startup \
      --replace-fail 'dbus-update-activation-environment' '${lib.getExe' dbus "dbus-update-activation-environment"}'
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    providedSessions = [ "miriway" ];
    tests = {
      inherit (nixosTests) miriway;
    };
  };

  meta = {
    description = "Mir based Wayland compositor";
    longDescription = ''
      Miriway is a starting point for creating a Wayland based desktop environment using Mir.

      At the core of Miriway is miriway-shell, a Mir based Wayland compositor that provides:

      - A "floating windows" window management policy;
      - Support for Wayland (and via Xwayland) X11 applications;
      - Dynamic workspaces;
      - Additional Wayland support for "shell components" such as panels and docs; and,
      - Configurable shortcuts for launching standard apps such as launcher and terminal emulator.

      In addition to miriway-shell, Miriway has:

      - A "terminal emulator finder" script miriway-terminal, that works with most terminal emulators;
      - A launch script miriway to simplify starting Miriway;
      - A default configuration file miriway-shell.config; and,
      - A greeter configuration miriway.desktop so Miriway can be selected at login

      Miriway has been tested with shell components from several desktop environments and there are notes on
      enabling these in miriway-shell.config.
    '';
    homepage = "https://github.com/Miriway/Miriway";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "miriway";
    maintainers = with lib.maintainers; [ OPNA2608 ];
  };
})
