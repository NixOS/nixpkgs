{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, nixosTests
, cmake
, pkg-config
, mir
, libxkbcommon
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "miriway";
  version = "unstable-2024-04-02";

  src = fetchFromGitHub {
    owner = "Miriway";
    repo = "Miriway";
    rev = "ff58ed8f9f646ce11b5a43f39a03f7a916d8d695";
    hash = "sha256-oqBGAAQxYoapCn2uvXFrc8L7P3lCXUCRbWE4q6Mp+oc=";
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
    updateScript = unstableGitUpdater { };
    providedSessions = [ "miriway" ];
    tests = {
      inherit (nixosTests) miriway;
    };
  };

  meta = with lib; {
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
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ OPNA2608 ];
  };
})
