{ stdenv, fetchurl, openssl, pkgconfig
, withPerl ? false, perl
, withPython ? false, python3
, withTcl ? false, tcl
, withCyrus ? true, cyrus_sasl
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "znc-${version}";
  version = "1.6.5";

  src = fetchurl {
    url = "http://znc.in/releases/archive/${name}.tar.gz";
    sha256 = "1jia6kq6bp8yxfj02d5vj9vqb4pylqcldspyjj6iz82kkka2a0ig";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ]
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
