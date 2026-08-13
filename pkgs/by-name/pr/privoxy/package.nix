{
  lib,
  stdenv,
  nixosTests,
  fetchpatch,
  fetchurl,
  autoreconfHook,
  zlib,
  pcre2,
  w3m-batch,
  man,
  openssl,
  brotli,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "privoxy";
  version = "4.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/ijbswa/Sources/${finalAttrs.version}%20%28stable%29/privoxy-${finalAttrs.version}-stable-src.tar.gz";
    hash = "sha256-I+RoblhIx0y2gMCcKBHwNXc57P5kH5xAcu5COZCSyXs=";
  };

  nativeBuildInputs = [
    autoreconfHook
    w3m-batch
    man
  ];

  buildInputs = [
    zlib
    pcre2
    openssl
    brotli
  ];

  makeFlags = [ "STRIP=" ];
  configureFlags = [
    "--with-openssl"
    "--with-brotli"
    "--enable-external-filters"
    "--enable-compression"
  ];

  postInstall = ''
    rm -r $out/var
  '';

  passthru.tests.privoxy = nixosTests.privoxy;

  meta = {
    homepage = "https://www.privoxy.org/";
    description = "Non-caching web proxy with advanced filtering capabilities";
    # When linked with mbedtls, the license becomes GPLv3 (or later), otherwise
    # GPLv2 (or later). See https://www.privoxy.org/user-manual/copyright.html
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "privoxy";
  };
})
