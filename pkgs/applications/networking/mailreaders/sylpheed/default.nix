{ lib, stdenv, fetchurl, pkg-config, gtk2, openssl ? null, gpgme ? null
, gpgSupport ? true, sslSupport ? true, fetchpatch }:

assert gpgSupport -> gpgme != null;
assert sslSupport -> openssl != null;

with lib;

stdenv.mkDerivation rec {
  pname = "sylpheed";
  version = "3.7.0";

  src = fetchurl {
    url = "https://sylpheed.sraoss.jp/sylpheed/v3.7/${pname}-${version}.tar.xz";
    sha256 = "0j9y5vdzch251s264diw9clrn88dn20bqqkwfmis9l7m8vmwasqd";
  };

  patches = [
    (fetchpatch {
      # patch upstream bug https://sylpheed.sraoss.jp/redmine/issues/306
      name = "patch-libsylph_ssl_c.patch";
      url = "https://cvsweb.openbsd.org/cgi-bin/cvsweb/~checkout~/ports/mail/sylpheed/patches/patch-libsylph_ssl_c?rev=1.4&content-type=text/plain";
      sha256 = "sha256-k9OwPtHrEjaxXdH0trNqXgJMhR8kjgtei9pi6OFvILk=";
    })
  ];

  patchFlags = [ "-p0" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk2 ]
    ++ optionals gpgSupport [ gpgme ]
    ++ optionals sslSupport [ openssl ];

  configureFlags = optional gpgSupport "--enable-gpgme"
    ++ optional sslSupport "--enable-ssl";

  meta = {
    homepage = "https://sylpheed.sraoss.jp/en/";
    description = "Lightweight and user-friendly e-mail client";
    maintainers = with maintainers; [ eelco ];
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2;
  };
}
