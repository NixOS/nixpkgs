{ stdenv, fetchurl, aalib, ncurses, xorg, libmikmod }:

stdenv.mkDerivation rec {
  name    = "bb-${version}";
  version = "1.3rc1";

  src = fetchurl {
    url    = "mirror://sourceforge/aa-project/bb/${version}/${name}.tar.gz";
    sha256 = "1i411glxh7g4pfg4gw826lpwngi89yrbmxac8jmnsfvrfb48hgbr";
  };

  buildInputs = [
    aalib ncurses libmikmod
    xorg.libXau xorg.libXdmcp xorg.libX11
  ];

  meta = with stdenv.lib; {
    homepage    = http://aa-project.sourceforge.net/bb;
    description = "AA-lib demo";
    license     = licenses.gpl2;
    maintainers = [ maintainers.rnhmjoj ];
    platforms   = platforms.unix;
  };
}
