{
  lib,
  stdenv,
  cmake,
  version,
  src,
  patches ? [ ],
  ...
}:

stdenv.mkDerivation {
  pname = "msgpack";
  inherit version;

  inherit src patches;

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "-DMSGPACK_BUILD_EXAMPLES=OFF";

  meta = {
    description = "MessagePack implementation for C and C++";
    homepage = "https://msgpack.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ redbaron ];
    platforms = lib.platforms.all;
  };
}
