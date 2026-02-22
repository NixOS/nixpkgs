{
  lib,
  stdenv,
  fetchurl,
  openssl,
  zlib,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "polygraph";
  version = "4.13.0";

  src = fetchurl {
    url = "http://www.web-polygraph.org/downloads/srcs/polygraph-${finalAttrs.version}-src.tgz";
    sha256 = "1rwzci3n7q33hw3spd79adnclzwgwlxcisc9szzjmcjqhbkcpj1a";
  };

  buildInputs = [
    openssl
    zlib
    ncurses
  ];

  meta = {
    homepage = "http://www.web-polygraph.org";
    description = "Performance testing tool for caching proxies, origin server accelerators, L4/7 switches, content filters, and other Web intermediaries";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
