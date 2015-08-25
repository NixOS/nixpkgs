{ stdenv, fetchurl, openssl, pkgconfig
, withPerl ? false, perl
, withPython ? false, python3
, withTcl ? false, tcl
, withCyrus ? true, cyrus_sasl
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "znc-1.6.1";

  src = fetchurl {
    url = "http://znc.in/releases/${name}.tar.gz";
    sha256 = "0h61nv5kx9k8prmhsffxhlprf7gjcq8vqhjjmqr6v3glcirkjjds";
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
    maintainers = with maintainers; [ viric ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
