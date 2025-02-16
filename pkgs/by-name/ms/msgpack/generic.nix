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

  cmakeFlags = lib.optional (stdenv.hostPlatform.notEquals stdenv.buildPlatform) "-DMSGPACK_BUILD_EXAMPLES=OFF";

  meta = with lib; {
    description = "MessagePack implementation for C and C++";
    homepage = "https://msgpack.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ redbaron ];
    platforms = platforms.all;
  };
}
