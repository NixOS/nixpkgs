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
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-c";
    rev = "refs/tags/c-${finalAttrs.version}";
    hash = "sha256-yL1+6w9l1Ccgrh8WXqvHv2yrb9QH+TrHIAFLXGoVuT0=";
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

  meta = with lib; {
    description = "MessagePack implementation for C";
    homepage = "https://github.com/msgpack/msgpack-c";
    changelog = "https://github.com/msgpack/msgpack-c/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.boost;
    maintainers = with maintainers; [ nickcao ];
  };
})
