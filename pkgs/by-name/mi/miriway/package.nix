{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  nixosTests,
  cmake,
  pkg-config,
  mir,
  libxkbcommon,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "miriway";
  version = "24.09";

  src = fetchFromGitHub {
    owner = "Miriway";
    repo = "Miriway";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-/0txc9ynC3rj9tbHwYNlDe2C1DlmjoE2Q2/uoBz2GFg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    mir
    libxkbcommon
  ];

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

      - A "floating windows" window managament policy;
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
