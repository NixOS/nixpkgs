{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hiredis-vip";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "vipshop";
    repo = "hiredis-vip";
    tag = finalAttrs.version;
    hash = "sha256-4oss4SgrcdlIo2T8dmp61+Gy4GtjPiaa2bjfMozPP/0=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  # Function are declared after they are used in the file, this is error since gcc-14.
  #   command.c:1668:9: error: implicit declaration of function 'free' [-Wimplicit-function-declaration]
  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  meta = {
    description = "C client library for the Redis database";
    homepage = "https://github.com/vipshop/hiredis-vip";
    license = lib.licenses.bsd3;
  };
})
