{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  protobuf,
  zlib,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "protobuf-c";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bpxk2o5rYLFkx532A3PYyhh2MwVH2Dqf3p/bnNpQV7s=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    protobuf
    zlib
  ];

  env.PROTOC = lib.getExe buildPackages.protobuf;

  meta = {
    homepage = "https://github.com/protobuf-c/protobuf-c/";
    description = "C bindings for Google's Protocol Buffers";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
