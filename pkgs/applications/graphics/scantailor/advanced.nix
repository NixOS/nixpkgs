{
  lib,
  fetchFromGitHub,
  mkDerivation,
  cmake,
  libjpeg,
  libpng,
  libtiff,
  boost,
  qtbase,
  qttools,
}:

mkDerivation rec {
  pname = "scantailor-advanced";
  version = "1.0.19";

  src = fetchFromGitHub {
    owner = "vigri";
    repo = "scantailor-advanced";
    rev = "v${version}";
    sha256 = "sha256-mvoCoYdRTgXW5t8yd9Y9TOl7D3RDVwcjUv2YDUWrtRI=";
  };

  nativeBuildInputs = [
    cmake
    qttools
  ];
  buildInputs = [
    libjpeg
    libpng
    libtiff
    boost
    qtbase
  ];

  meta = with lib; {
    homepage = "https://github.com/vigri/scantailor-advanced";
    description = "Interactive post-processing tool for scanned pages (vigri's fork)";
    mainProgram = "scantailor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = with platforms; gnu ++ linux ++ darwin;
  };
}
