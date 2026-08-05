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
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-c";
    tag = "cpp-${finalAttrs.version}";
    hash = "sha256-11eRM63rjmbIi0glwY5dEuKG9wnVOLx8VXb7CXqCbJE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
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

  meta = {
    description = "MessagePack implementation for C++";
    homepage = "https://github.com/msgpack/msgpack-c";
    changelog = "https://github.com/msgpack/msgpack-c/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
