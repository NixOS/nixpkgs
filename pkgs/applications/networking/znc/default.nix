{ stdenv, fetchurl, openssl, pkgconfig
, withPerl ? false, perl
, withPython ? false, python3
, withTcl ? false, tcl
, withCyrus ? true, cyrus_sasl
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "znc-${version}";
  version = "1.6.4";

  src = fetchurl {
    url = "http://znc.in/releases/${name}.tar.gz";
    sha256 = "070d6b1i3jy66m4ci4ypxkg4pbwqbzbzss1y1ycgq2w62zmrf423";
  };

  buildInputs = [ openssl pkgconfig ]
    ++ optional withPerl perl
    ++ optional withPython python3
    ++ optional withTcl tcl
    ++ optional withCyrus cyrus_sasl;

  configureFlags = optionalString withPerl "--enable-perl "
    + optionalString withPython "--enable-python "
    + optionalString withTcl "--enable-tcl --with-tcl=${tcl}/lib "
    + optionalString withCyrus "--enable-cyrus ";

  meta = with stdenv.lib; {
    description = "Advanced IRC bouncer";
    homepage = http://wiki.znc.in/ZNC;
    maintainers = with maintainers; [ viric schneefux lnl7 ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
