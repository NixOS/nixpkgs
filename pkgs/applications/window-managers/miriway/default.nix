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

stdenv.mkDerivation rec {
  pname = "miriway";
  version = "unstable-2023-04-25";

  src = fetchFromGitHub {
    owner = "Miriway";
    repo = "Miriway";
    rev = "55ef5bd188e2b86dfbd1b9b360d832d4cd454eb7";
    hash = "sha256-kooyL5up+SBHmnv/eEnsg0ujJlHBqbE+n/YHqmpXscI=";
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
}
