{ stdenv, fetchurl, openssl, pkgconfig
, withPerl ? false, perl
, withPython ? false, python3
, withTcl ? false, tcl
, withCyrus ? true, cyrus_sasl
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "znc-1.6.3";

  src = fetchurl {
    url = "http://znc.in/releases/${name}.tar.gz";
    sha256 = "09xqi5fs40x6nj9gq99bnw1a7saq96bvqxknxx0ilq7yfvg4c733";
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
    maintainers = with maintainers; [ viric schneefux ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
