{ stdenv, fetchurl, pkgconfig, gtk2
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
  version = "3.5.1";

  src = fetchurl {
    url = "http://sylpheed.sraoss.jp/sylpheed/v3.5/${name}.tar.bz2";
    sha256 = "11qhbfyvi5hxv1f448zgbzgrdjj3a4mxj2bfpk6k4bqf7ahh8nis";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs =
    [ gtk2 ]
    ++ optional sslSupport openssl
    ++ optional gpgSupport gpgme;

  configureFlags = optional sslSupport "--enable-ssl"
                ++ optional gpgSupport "--enable-gpgme";

  meta = {
    homepage = http://sylpheed.sraoss.jp/en/;
    description = "A lightweight and user-friendly e-mail client";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.linux ++ platforms.darwin;
    license = "GPL";
  };
}
