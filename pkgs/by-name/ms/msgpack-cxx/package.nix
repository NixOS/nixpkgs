{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "msgpack-cxx";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-c";
    tag = "cpp-${finalAttrs.version}";
    hash = "sha256-kg4mpNiigfZ59ZeL8LXEHwtkLU8Po+vgRcUcgTJd+h4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
  ];

  cmakeFlags = [
    "-DMSGPACK_BUILD_DOCS=OFF" # docs are not installed even if built
    "-DMSGPACK_CXX20=ON"
  ]
  ++ lib.optional finalAttrs.finalPackage.doCheck "-DMSGPACK_BUILD_TESTS=ON";

  checkInputs = [
    zlib
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = with lib; {
    description = "MessagePack implementation for C++";
    homepage = "https://github.com/msgpack/msgpack-c";
    changelog = "https://github.com/msgpack/msgpack-c/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.boost;
    maintainers = with maintainers; [ nickcao ];
  };
})
