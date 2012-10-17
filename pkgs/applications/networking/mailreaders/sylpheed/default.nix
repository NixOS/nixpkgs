{ sslSupport ? true
, gpgSupport ? false
, stdenv, fetchurl, pkgconfig, gtk
, openssl ? null
, gpgme ? null
}:

with stdenv.lib;

assert sslSupport -> openssl != null;
assert gpgSupport -> gpgme != null;

stdenv.mkDerivation {
  name = "sylpheed-3.2";

  src = fetchurl {
    url = http://sylpheed.sraoss.jp/sylpheed/v3.2/sylpheed-3.2.0.tar.bz2;
    sha256 = "1cdjwn1f8rgcxzfxj7j7qvacmaw4zfhnip81q4n5lj5d6rj7rssa";
  };

  buildInputs =
    [ pkgconfig gtk ]
    ++ optional sslSupport openssl
    ++ optional gpgSupport gpgme;

  configureFlags = optionalString sslSupport "--enable-ssl";

  meta = {
    homepage = http://sylpheed.sraoss.jp/en/;
    description = "A lightweight and user-friendly e-mail client";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.linux;
    license = "GPL";
  };
}
