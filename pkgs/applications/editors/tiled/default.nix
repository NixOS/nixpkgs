{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, qmake
, python, qtbase, qttools }:

mkDerivation rec {
  pname = "tiled";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "bjorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b3xjcc86vs9lfxr7xann9d43dz3v3x1g7j1mcn31sy2n68a1wx3";
  };

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [ python qtbase qttools ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Free, easy to use and flexible tile map editor";
    homepage = "https://www.mapeditor.org/";
    license = with licenses; [
      bsd2	# libtiled and tmxviewer
      gpl2Plus	# all the rest
    ];
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.linux;
  };
}
