{
  lib,
  stdenv,
  fetchFromGitHub,
  unzip,
  pkg-config,
  glib,
  llvm,
  llvmPackages,
}:

stdenv.mkDerivation {
  pname = "milu-nightly";
  version = "2016-05-09";

  src = fetchFromGitHub {
    owner = "yuejia";
    repo = "Milu";
    rev = "b5f2521859c0319d321ad3c1ad793b826ab5f6e1";
    hash = "sha256-0w7SOZONj2eLX/E0VIrCZutSXTY648P3pTxSRgCnj5E=";
  };

  hardeningDisable = [ "format" ];

  preConfigure = ''
    sed -i 's#/usr/bin/##g' Makefile
  '';

  nativeBuildInputs = [
    pkg-config
    unzip
  ];

  buildInputs = [
    glib
    llvm.dev
    llvmPackages.libclang
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-incompatible-pointer-types"
    "-Wno-implicit-function-declaration"
    "-Wno-error=int-conversion"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/milu $out/bin
  '';

  meta = {
    description = "Higher Order Mutation Testing Tool for C and C++ programs";
    homepage = "https://github.com/yuejia/Milu";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "milu";
  };
}
