{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, qmake
, python, qtbase, qttools }:

mkDerivation rec {
  pname = "tiled";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "bjorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "0v8imw6zdygs9ymsgk41jclsfr1jwbracjc5balydh15r57rvwjd";
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
