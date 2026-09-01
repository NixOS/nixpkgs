{
  lib,
  stdenv,
  fetchurl,
  openssl,
  libidn,
  glib,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.5.4";
  pname = "loudmouth";

  src = fetchurl {
    url = "https://mcabber.com/files/loudmouth/loudmouth-${finalAttrs.version}.tar.bz2";
    hash = "sha256-McvJHB/dzFNGszc7j7RVlOnqnMf+NtBZXokSxHrZTQ0=";
  };

  configureFlags = [ "--with-ssl=openssl" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  propagatedBuildInputs = [
    openssl
    libidn
    glib
    zlib
  ];

  nativeBuildInputs = [ pkg-config ];

  meta = {
    changelog = "https://mcabber.com/";
    description = "Lightweight C library for the Jabber protocol";
    platforms = lib.platforms.all;
    downloadPage = "http://mcabber.com/files/loudmouth/";
    license = lib.licenses.lgpl21;
  };
})
