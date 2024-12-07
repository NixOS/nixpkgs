{
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation {
  pname = "shellstorm-qt";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "algoatson";
    repo = "shellstorm-qt";
    rev = "b8bc420773fa08caa7846b75fb388b9fae6cd8ec"; # or another commit, tag, or branch
    sha256 = "sha256-KbdqGVqOz8CLPBOGiC5qsOpLW4Rzoalnsl0l55afJ7s";
  };

  buildInputs = [
    qt6.qtbase
    qt6.full
  ];

  configurePhase = ''
    cd src
    cmake .
  '';

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildPhase = ''
    cmake --build . --config Release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./shellstorm-qt $out/bin/
  '';
}
