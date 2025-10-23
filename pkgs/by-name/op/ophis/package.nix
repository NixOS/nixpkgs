{
  lib,
  fetchFromGitHub,
  python3Packages,
  unstableGitUpdater,
}:

let
  self = python3Packages.buildPythonApplication {
    pname = "ophis";
    version = "2.2-unstable-2024-07-28";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "michaelcmartin";
      repo = "Ophis";
      rev = "6a5e5a586832e828b598e8162457e673a6c38275";
      hash = "sha256-cxgSgAypS02AO9vjYjNWDY/cx7kxLt1Bdw8HGgGGBhU=";
    };

    build-system = [ python3Packages.setuptools ];

    passthru = {
      updateScript = unstableGitUpdater { };
    };

    meta = {
      homepage = "http://michaelcmartin.github.io/Ophis/";
      description = "Cross-assembler for the 6502 series of microprocessors";
      longDescription = ''
        Ophis is an assembler for the 6502 microprocessor - the famous chip used
        in the vast majority of the classic 8-bit computers and consoles. Its
        primary design goals are code readability and output flexibility - Ophis
        has successfully been used to create programs for the Nintendo
        Entertainment System, the Atari 2600, and the Commodore 64.
      '';
      license = lib.licenses.mit;
      mainProgram = "ophis";
      maintainers = [ ];
    };
  };
in
self
