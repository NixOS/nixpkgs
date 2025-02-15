{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  protobuf_25,
  zlib,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "protobuf-c";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
    tag = "v${version}";
    hash = "sha256-usfONVSq0/V9GRrBx9RwO/hCrVJ8d17mvAgTKpKUssQ=";
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
    protobuf_25
    zlib
  ];

  env.PROTOC = lib.getExe buildPackages.protobuf_25;

  meta = with lib; {
    homepage = "https://github.com/protobuf-c/protobuf-c/";
    description = "C bindings for Google's Protocol Buffers";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ nickcao ];
  };
}
