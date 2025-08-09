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
  version = "2.0.6";

  src = fetchurl {
    url = "http://www.liblognorm.com/files/download/liblognorm-${finalAttrs.version}.tar.gz";
    hash = "sha256-z/BX6FwiA4mS+e0S641OY8Ra31OlpR+qoyefYFgJ9vI=";
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
