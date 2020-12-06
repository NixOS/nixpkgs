{ mkDerivation, stdenv, fetchFromGitHub, qtbase, qmake, exiv2 }:

mkDerivation rec {
  pname = "phototonic";
  version = "2.1";

  src = fetchFromGitHub {
    repo = "phototonic";
    owner = "oferkv";
    rev = "v${version}";
    sha256 = "0csidmxl1sfmn6gq81vn9f9jckb4swz3sgngnwqa4f75lr6604h7";
  };

  buildInputs = [ qtbase exiv2 ];
  nativeBuildInputs = [ qmake ];

  preConfigure = ''
    sed -i 's;/usr;$$PREFIX/;g' phototonic.pro
  '';

  meta = with stdenv.lib; {
    description = "An image viewer and organizer";
    homepage = "https://sourceforge.net/projects/phototonic/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
