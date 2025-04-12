{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "msgpack-cxx";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-c";
    rev = "refs/tags/cpp-${finalAttrs.version}";
    hash = "sha256-m0Ki+9/nZo2b4BUT+gUtdxok5I7xQtcfnMkbG+OHsKs=";
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
  ] ++ lib.optional finalAttrs.finalPackage.doCheck "-DMSGPACK_BUILD_TESTS=ON";

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
