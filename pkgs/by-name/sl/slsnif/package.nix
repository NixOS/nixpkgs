{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "slsnif";
  version = "0.4.4";

  src = fetchurl {
    url = "mirror://sourceforge/slsnif/slsnif-${version}.tar.gz";
    sha256 = "0gn8c5hj8m3sywpwdgn6w5xl4rzsvg0z7d2w8dxi6p152j5b0pii";
  };

  meta = {
    description = "Serial line sniffer";
    homepage = "http://slsnif.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "slsnif";
  };
}
