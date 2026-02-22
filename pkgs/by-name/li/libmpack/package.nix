{
  lib,
  stdenv,
  fetchFromGitHub,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmpack";
  version = "1.0.5";
  src = fetchFromGitHub {
    owner = "libmpack";
    repo = "libmpack";
    rev = finalAttrs.version;
    sha256 = "0rai5djdkjz7bsn025k5489in7r1amagw1pib0z4qns6b52kiar2";
  };

  makeFlags = [
    "LIBTOOL=${libtool}/bin/libtool"
    "PREFIX=$(out)"
    "config=release"
  ];

  meta = {
    description = "Simple implementation of msgpack in C";
    homepage = "https://github.com/tarruda/libmpack/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovek323 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
