{stdenv, fetchurl, openssl, pkgconfig
, withPerl ? false, perl
, withPython ? false, python3
, withTcl ? false, tcl
, withCyrus ? true, cyrus_sasl
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "znc-1.0";
  src = fetchurl {
    url = "http://znc.in/releases/${name}.tar.gz";
    sha256 = "0ah6890ngvj97kah3x7fd8yzi6dpdgrxw1b2skj2cyv98bd3jmd8";
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

  meta = {
    description = "Advanced IRC bouncer";
    homepage = http://wiki.znc.in/ZNC;
    maintainers = [ stdenv.lib.maintainers.viric ];
    license = "ASL2.0";
    platforms = stdenv.lib.platforms.unix;
  };
}
