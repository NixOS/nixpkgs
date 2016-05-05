{ stdenv, fetchurl, pkgconfig, gtk

, openssl ? null
, gpgme ? null
, sslSupport ? true
, gpgSupport ? true
}:

with stdenv.lib;

assert sslSupport -> openssl != null;
assert gpgSupport -> gpgme != null;

stdenv.mkDerivation rec {
  name = "sylpheed-${version}";
  version = "3.5.0";

  src = fetchurl {
    url = "http://sylpheed.sraoss.jp/sylpheed/v3.5/${name}.tar.bz2";
    sha256 = "0p50cr9h8b7cv1ayxhqxpj3kv0b7k9dga7lmmfb1lvyagg8n42sa";
  };

  buildInputs =
    [ pkgconfig gtk ]
    ++ optional sslSupport openssl
    ++ optional gpgSupport gpgme;

  configureFlags = optional sslSupport "--enable-ssl"
                ++ optional gpgSupport "--enable-gpgme";

  meta = {
    homepage = http://sylpheed.sraoss.jp/en/;
    description = "A lightweight and user-friendly e-mail client";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.linux;
    license = "GPL";
  };
}
