{ stdenv, fetchurl, openssl, pkgconfig, gnutls, gsasl, libidn, Security }:

stdenv.mkDerivation rec {
  version = "1.2.4";
  name = "mpop-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/mpop/${name}.tar.xz";
    sha256 = "158zl6clxrl2id4kvdig2lvdvm0vg2byqcgn1dnxfjg5mw16ngwk";
  };

  buildInputs = [ openssl pkgconfig gnutls gsasl libidn ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  configureFlags =
    stdenv.lib.optional stdenv.isDarwin [ "--with-macosx-keyring" ];

  meta = {
      description = "POP3 mail retrieval agent";
      homepage = "http://mpop.sourceforge.net/";
      license = stdenv.lib.licenses.gpl3Plus;
      platforms = stdenv.lib.platforms.unix;
    };
}
