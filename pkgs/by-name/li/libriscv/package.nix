{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
}:
let
  tinycc = fetchFromGitHub {
    owner = "fwsGonzo";
    repo = "tinycc";
    rev = "5f89cb5d2d62b614ecbef572e1dd66d25fe46647";
    hash = "sha256-Y1JCceuDldBtqusNNFgPJOjbI0wHGggJUOU4JLHvFKU=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "libriscv";
  version = "unstable-2026-07-25";

  src = fetchFromGitHub {
    owner = "libriscv";
    repo = "libriscv";
    rev = "ee8949358087e8f01e2c0fce97ace08f7bfc6655";
    hash = "sha256-XzRpQ/6es69NM4UE3/kqDgAoDtCs5ImQBcWwmKvUbks=";
    version = finalAttrs.version;
  };

  nativeBuildInputs = [
    cmake
  ];

  postPatch = ''
    mkdir -p _deps/
    cp -r ${tinycc} _deps/tinycc
    chmod -R +w _deps/tinycc
  '';

  cmakeFlags = [
    "-DFETCHCONTENT_SOURCE_DIR_TINYCC=../_deps/tinycc"
  ];

  meta = {
    homepage = "https://github.com/libriscv/libriscv";
    description = "The fastest RISC-V sandbox";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
