{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libestr,
  json_c,
  pcre,
  fastJson,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblognorm";
  version = "2.0.7";

  src = fetchurl {
    url = "http://www.liblognorm.com/files/download/liblognorm-${finalAttrs.version}.tar.gz";
    hash = "sha256-vp2OekIHAu2NPFvK1zBsLZxs9UtZx3FcYbCIoGDgiUM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libestr
    json_c
    pcre
    fastJson
  ];

  configureFlags = [ "--enable-regexp" ];

  meta = {
    description = "Help to make sense out of syslog data, or, actually, any event data that is present in text form";
    homepage = "https://www.liblognorm.com/";
    license = lib.licenses.lgpl21;
    mainProgram = "lognormalizer";
    platforms = lib.platforms.all;
  };
})
