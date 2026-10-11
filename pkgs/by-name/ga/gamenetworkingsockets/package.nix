{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  go,
  protobuf_21,
  openssl,
}:
let
  protobuf = protobuf_21;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "GameNetworkingSockets";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "GameNetworkingSockets";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fV/V7+f8xSZ/nSnSycNKN3cjx0KxX+Dpj21RZ7Cpu24=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    go
  ];

  cmakeFlags = [ "-G Ninja" ];

  # tmp home for go
  preBuild = "export HOME=\"$TMPDIR\"";

  buildInputs = [ protobuf ];
  propagatedBuildInputs = [ openssl ];

  meta = {
    description = "GameNetworkingSockets is a basic transport layer for games";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    inherit (finalAttrs.src.meta) homepage;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
