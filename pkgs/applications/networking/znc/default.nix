{ stdenv, fetchurl, openssl, pkgconfig
, withPerl ? false, perl
, withPython ? false, python3
, withTcl ? false, tcl
, withCyrus ? true, cyrus_sasl
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "znc-${version}";
  version = "1.7.1";

  src = fetchurl {
    url = "https://znc.in/releases/archive/${name}.tar.gz";
    sha256 = "1i1r1lh9q2mr1bg520zrvrlwhrhy6wibrin78wjxq1gab1qymks4";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ]
    ++ optional withPerl perl
    ++ optional withPython python3
    ++ optional withTcl tcl
    ++ optional withCyrus cyrus_sasl;

  configureFlags = [
    (stdenv.lib.enableFeature withPerl "perl")
    (stdenv.lib.enableFeature withPython "python")
    (stdenv.lib.enableFeature withTcl "tcl")
    (stdenv.lib.withFeatureAs withTcl "tcl" "${tcl}/lib")
    (stdenv.lib.enableFeature withCyrus "cyrus")
  ];

  meta = with stdenv.lib; {
    description = "Advanced IRC bouncer";
    homepage = https://wiki.znc.in/ZNC;
    maintainers = with maintainers; [ schneefux lnl7 ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
