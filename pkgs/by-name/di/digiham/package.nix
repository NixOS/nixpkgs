{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  protobuf,
  icu,
  csdr,
  codecserver,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "digiham";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "jketterl";
    repo = "digiham";
    tag = finalAttrs.version;
    hash = "sha256-v7qp6Lv94Ec0yzHsc08YDfE5OU54nglosRLWb98yDiQ=";
  };

  patches = [
    # libicu headers require C++ 17, remove `set(CMAKE_CXX_STANDARD 11)`
    ./cpp-17.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    codecserver
    protobuf
    csdr
    icu
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/dmr_decoder";
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/jketterl/digiham";
    description = "Tools for decoding digital ham communication";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
  };
})
