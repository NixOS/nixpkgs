{ stdenv, fetchurl, cmake, qt4, libXfixes, libXtst}:

let version = "2.5.0";
in
stdenv.mkDerivation {
  name = "CopyQ-${version}";
  src  = fetchurl {
    url    = "https://github.com/hluk/CopyQ/archive/v${version}.tar.gz";
    sha256 = "7726745056e8d82625531defc75b2a740d3c42131ecce1f3181bc0a0bae51fb1";
  };

  buildInputs = [ cmake qt4 libXfixes libXtst ];

  meta = with stdenv.lib; {
    homepage    = "https://hluk.github.io/CopyQ";
    description = "Clipboard Manager with Advanced Features";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ willtim ];
    # NOTE: CopyQ supports windows and osx, but I cannot test these.
    # OSX build requires QT5.
    platforms   = platforms.linux;
  };
}
