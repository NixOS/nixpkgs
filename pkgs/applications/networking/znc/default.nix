{ stdenv, fetchurl, openssl, pkgconfig
, withPerl ? false, perl
, withPython ? false, python3
, withTcl ? false, tcl
, withCyrus ? true, cyrus_sasl
, withUnicode ? true, icu
, withZlib ? true, zlib
, withIPv6 ? true
, withDebug ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "znc";
  version = "1.7.5";

  src = fetchurl {
    url = "https://znc.in/releases/archive/${pname}-${version}.tar.gz";
    sha256 = "08a7yb2xs85hyyz8dpzfbsfjwj2r6kcii022lj3l4rf8hl9ix558";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ]
    ++ optional withPerl perl
    ++ optional withPython python3
    ++ optional withTcl tcl
    ++ optional withCyrus cyrus_sasl
    ++ optional withUnicode icu
    ++ optional withZlib zlib;

  configureFlags = [
    (stdenv.lib.enableFeature withPerl "perl")
    (stdenv.lib.enableFeature withPython "python")
    (stdenv.lib.enableFeature withTcl "tcl")
    (stdenv.lib.withFeatureAs withTcl "tcl" "${tcl}/lib")
    (stdenv.lib.enableFeature withCyrus "cyrus")
  ] ++ optional (!withIPv6) [ "--disable-ipv6" ]
    ++ optional withDebug [ "--enable-debug" ];

  meta = with stdenv.lib; {
    description = "Advanced IRC bouncer";
    homepage = https://wiki.znc.in/ZNC;
    maintainers = with maintainers; [ schneefux lnl7 ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
