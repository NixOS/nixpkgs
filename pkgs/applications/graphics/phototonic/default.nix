{ stdenv, fetchFromGitHub, qtbase, exiv2 }:

stdenv.mkDerivation rec {
  name = "phototonic-${version}";
  version = "1.7.1";

  src = fetchFromGitHub {
    repo = "phototonic";
    owner = "oferkv";
    # There is currently no tag for 1.7.1 see
    # https://github.com/oferkv/phototonic/issues/214
    rev = "c37070e4a068570d34ece8de1e48aa0882c80c5b";
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
