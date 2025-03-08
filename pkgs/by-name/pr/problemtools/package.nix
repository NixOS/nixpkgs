{
  fetchFromGitHub,
  python3Packages,
  automake,
  autoconf,
  boost,
  gmp,
  lib,
}: let
  version = "1.20231016";
in
  python3Packages.buildPythonApplication {
    inherit version;
    pname = "problemtools";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "kattis";
      repo = "problemtools";
      rev = version;
      hash = "sha256-3Tk+GMIAbnUMg/PvEYvU8ADbQunmGrD8mWDxmMjS5cY=";
      fetchSubmodules = true;
    };

    patches = [./remove-git.patch];

    nativeBuildInputs = [
      python3Packages.setuptools
      automake
      autoconf
    ];

    propagatedBuildInputs = [
      gmp
      boost
      python3Packages.pyyaml
      python3Packages.plasTeX
    ];

    meta = {
      description = "Tools to manage problem packages using the Kattis problem package format";
      license = lib.licenses.mit;
      mainProgram = "verifyproblem";
      maintainers = with lib.maintainers; [TheColorman];
      homepage = "https://github.com/Kattis/problemtools";
      platforms = lib.platforms.linux;
    };
  }
