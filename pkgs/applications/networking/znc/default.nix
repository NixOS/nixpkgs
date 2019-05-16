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
  name = "znc-${version}";
  version = "1.7.3";

  src = fetchurl {
    url = "https://znc.in/releases/archive/${name}.tar.gz";
    sha256 = "0g8i5hsl4kinpz1wp0a2zniidv3w2sd6awq8676fds516wcc6k0y";
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
