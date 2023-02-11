{ lib, fetchFromGitHub, mkDerivation
, cmake, libjpeg, libpng, libtiff, boost
, qtbase, qttools }:

mkDerivation rec {
  pname = "scantailor-advanced";
  version = "1.0.18";

  src = fetchFromGitHub {
    owner = "vigri";
    repo = "scantailor-advanced";
    rev = "v${version}";
    sha256 = "sha256-4/QSjgHvRgIduS/AXbT7osRTdOdgR7On3CbjRnGbwHU=";
  };

  nativeBuildInputs = [ cmake qttools ];
  buildInputs = [ libjpeg libpng libtiff boost qtbase ];

  meta = with lib; {
    homepage = "https://github.com/vigri/scantailor-advanced";
    description = "Interactive post-processing tool for scanned pages (vigri's fork)";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jfrankenau ];
    platforms = with platforms; gnu ++ linux ++ darwin;
  };
}
