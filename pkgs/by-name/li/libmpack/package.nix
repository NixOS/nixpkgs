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
    hash = "sha256-Iqs4RVlGW0w+WPEG/lRVIR8bEyJlFgGsXufL2WQrUWU=";
  };

  preBuild = lib.optionalString stdenv.hostPlatform.isStatic ''
    mkdir -p build/release/src build/release/test/deps/tap
  '';

  makeFlags = [
    "LIBTOOL=${libtool}/bin/libtool"
    "PREFIX=$(out)"
    "config=release"
  ];

  meta = {
    description = "Simple implementation of msgpack in C";
    homepage = "https://github.com/tarruda/libmpack/";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
