{ stdenv, fetchFromGitHub, qtbase, exiv2 }:

stdenv.mkDerivation rec {
  name = "phototonic-${version}";
  version = "1.7";

  src = fetchFromGitHub {
    repo = "phototonic";
    owner = "oferkv";
    rev = "v${version}";
    sha256 = "1agd3bsrpljd019qrjvlbim5l0bhpx53dhpc0gvyn0wmcdzn92gj";
  };

  buildInputs = [ qtbase exiv2 ];

  configurePhase = ''
    sed -i 's;/usr;;' phototonic.pro
    qmake PREFIX=""
  '';

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = with stdenv.lib; {
    description = "An image viewer and organizer";
    homepage = http://oferkv.github.io/phototonic/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
