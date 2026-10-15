{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hotpatch";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "vikasnkumar";
    repo = "hotpatch";
    rev = "4b65e3f275739ea5aa798d4ad083c4cb10e29149";
    hash = "sha256-EEuM0tQwtdDH2Gr6PA/8LppNTMf/UlSoM3ZpXgpsO5k=";
  };

  doCheck = true;

  nativeBuildInputs = [ cmake ];

  preConfigure = ''
    substituteInPlace test/loader.c \
      --replace \"/lib64/ld-linux-x86-64.so.2 \""$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --replace \"/lib/ld-linux-x86-64.so.2 \""$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --replace \"/lib/ld-linux.so.2 \""$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --replace \"/lib32/ld-linux.so.2 \""$(cat $NIX_CC/nix-support/dynamic-linker)"
  '';

  checkPhase = ''
    LD_LIBRARY_PATH=$(pwd)/src make test
  '';

  patches = [ ./no-loader-test.patch ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 2.6 FATAL_ERROR)' \
      'cmake_minimum_required(VERSION 4.0)'
  '';

  meta = {
    description = "Hot patching executables on Linux using .so file injection";
    mainProgram = "hotpatcher";
    homepage = finalAttrs.src.meta.homepage;
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
})
