{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage {
  pname = "gladtex";
  version = "unstable-2023-01-22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "humenda";
    repo = "GladTeX";
    rev = "f84e63836622ff1325dfddc7c5649f11a795afa0";
    sha256 = "sha256-B5sNEmLO4iIJRDgcPhr9LFKV77dPJws8ITNz4R+FE08=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  meta = {
    description = "Embed LaTeX formulas into HTML documents as SVG images";
    mainProgram = "gladtex";
    homepage = "https://humenda.github.io/GladTeX";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pentane ];
  };
}
