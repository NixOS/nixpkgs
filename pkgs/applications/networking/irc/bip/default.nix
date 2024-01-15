{ lib
, stdenv
, fetchurl
, pkg-config
, autoconf
, automake
, bison
, flex
, openssl
}:

stdenv.mkDerivation {
  pname = "bip";
  version = "0.9.3";

  src = fetchurl {
    # Note that the number behind download is not predictable
    url = "https://projects.duckcorp.org/attachments/download/146/bip-0.9.3.tar.gz";
    hash = "sha256-K+6AC8mg0aLQsCgiDoFBM5w2XrR+V2tfWnI8ByeRmOI=";
  };

  outputs = [ "out" "man" "doc" ];

  nativeBuildInputs = [ pkg-config autoconf automake ];
  buildInputs = [ bison flex openssl ];

  # FIXME: Openssl3 deprecated PEM_read_DHparams and DH_free
  # https://projects.duckcorp.org/issues/780
  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  meta = {
    description = "An IRC proxy (bouncer)";
    homepage = "http://bip.milkypond.org/";
    license = lib.licenses.gpl2;
    downloadPage = "https://projects.duckcorp.org/projects/bip/files";
    platforms = lib.platforms.linux;
  };
}
