{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "msgpack-c";
  version = "7.0.2";

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-c";
    tag = "c-${finalAttrs.version}";
    hash = "sha256-7wAYsrB23MIUL+tg3OrSSbNWX01500z1ck8zpiQjS8U=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "MSGPACK_BUILD_EXAMPLES" false) # examples are not installed even if built
    (lib.cmakeBool "MSGPACK_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  checkInputs = [
    gtest
    zlib
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = {
    description = "MessagePack implementation for C";
    homepage = "https://github.com/msgpack/msgpack-c";
    changelog = "https://github.com/msgpack/msgpack-c/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
