{ sslSupport ? true
, gpgSupport ? false
, stdenv, fetchurl, pkgconfig, gtk
, openssl ? null
, gpgme ? null
}:

with stdenv.lib;

assert sslSupport -> openssl != null;
assert gpgSupport -> gpgme != null;

let version = "3.4.1"; in

stdenv.mkDerivation {
  name = "sylpheed-${version}";

  src = fetchurl {
    url = "http://sylpheed.sraoss.jp/sylpheed/v3.4/sylpheed-${version}.tar.bz2";
    sha256 = "11wpifvn8a0p4dqmvi7r61imqkgm6rjjp3h057c344vny37livbx";
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
