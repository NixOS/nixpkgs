{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "gladtex";
  version = "unstable-2023-01-22";

  src = fetchFromGitHub {
    owner = "humenda";
    repo = "GladTeX";
    rev = "f84e63836622ff1325dfddc7c5649f11a795afa0";
    sha256 = "sha256-B5sNEmLO4iIJRDgcPhr9LFKV77dPJws8ITNz4R+FE08=";
  };

  meta = with lib; {
    description = "Embed LaTeX formulas into HTML documents as SVG images";
    mainProgram = "gladtex";
    homepage = "https://humenda.github.io/GladTeX";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ alyaeanyx ];
  };
}
