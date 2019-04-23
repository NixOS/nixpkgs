{ stdenv, fetchFromGitHub, pkgconfig, cmake, libeb, lzo, qtbase
, qtmultimedia, qttools, qtwebengine }:

stdenv.mkDerivation rec {
  name = "qolibri-${version}";
  version = "2018-11-14";

  src = fetchFromGitHub {
    owner = "ludios";
    repo = "qolibri";
    rev = "133a1c33e74d931ad54407f70d84a0016d96981f";
    sha256 = "16ifix0q8ww4l3xflgxr9j81c0lzlnkjr8fj961x3nxz7288pdg2";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [
    libeb lzo qtbase qtmultimedia qttools qtwebengine
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/ludios/qolibri;
    description = "EPWING reader for viewing Japanese dictionaries";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ivan ];
    license = licenses.gpl2;
  };
}
