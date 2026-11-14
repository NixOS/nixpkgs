{
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  makeWrapper,
  lib,
  zlib,
  glibc,
  musl,
  zig_0_17,
  llvm_22,
  lld_22,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flintc";
  date = "2026-11-11";
  version = "0.4.2-unstable-${finalAttrs.date}";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  outputBin = "out";
  outputLib = "lib";
  outputDev = "dev";
  outputInclude = "dev";

  src = fetchFromGitHub {
    owner = "flint-lang";
    repo = "flintc";
    # tag = "v${finalAttrs.version}-core";
    rev = "f72e7f2421244a821b250990b9f4b5b542636a84";
    sha256 = "sha256-F2+EGthlfPNYBVwCfcxNneKSIvKocl3fD44PDPnV3gM=";
  };

  fipSrc = fetchFromGitHub {
    owner = "flint-lang";
    repo = "fip";
    rev = "306dc342e37258832bdc216c049cd3cdaa312245";
    sha256 = "sha256-0uq9njGpKQ77Oz3PYocQnGu4xz9SO14Y/AhVJJ1GWzA=";
  };

  tomlc17Src = fetchFromGitHub {
    owner = "cktan";
    repo = "tomlc17";
    rev = "R250712";
    sha256 = "sha256-0if07Zj7Og+DBc/gxmAEHQh7QwAo8C/4S+x9IttEUjI=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    zig_0_17
    llvm_22
    lld_22
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    llvm_22.lib
    lld_22.lib
    stdenv.cc.cc.lib
    zlib
  ];

  dontSetZigDefaultFlags = true;
  enableParallelBuilding = true;
  dontAddPrefix = true;

  zigBuildFlags = [
    "-Dllvm-dynamic"
    "-Dstdcpp-include=${stdenv.cc.cc}/include/c++/${stdenv.cc.cc.version}:${stdenv.cc.cc}/include/c++/${stdenv.cc.cc.version}/x86_64-unknown-linux-gnu:${stdenv.cc.cc}/lib/gcc/x86_64-unknown-linux-gnu/${stdenv.cc.cc.version}/include"
    "-Dstdcpp-lib=${stdenv.cc.cc.lib}/lib/libstdc++.so"
    "-Dglibc-include=${glibc.dev}/include"
    "-Dglibc-lib=${glibc}/lib"
    "-Dmusl-lib=${musl}/lib"
    "-Dllvm-include=${llvm_22.dev}/include"
    "-Dllvm-lib=${llvm_22.lib}/lib"
    "-Dlld-include=${lld_22.dev}/include"
    "-Dlld-lib=${lld_22.lib}/lib"
    "-Dzlib-lib=${zlib}/lib"
    "-Dfip-source=${finalAttrs.fipSrc}"
    "-Dtomlc17-source=${finalAttrs.tomlc17Src}"
    "-Dcommit-hash=${builtins.substring 0 7 finalAttrs.src.rev}"
    "-Dcommit-date=${finalAttrs.date}"
    "--release=small"
  ];

  zigInstallFlags = [
    "--prefix-exe-dir"
    "${placeholder "out"}/bin"
    "--prefix-lib-dir"
    "${placeholder "lib"}/lib"
    "--prefix-include-dir"
    "${placeholder "dev"}/include"
  ];

  postFixup = ''
    wrapProgram "$out/bin/flintc" \
      --prefix PATH : "${lib.makeBinPath [ lld_22 ]}"
  '';

  meta = with lib; {
    description = "Flint programming language compiler and language server";
    homepage = "https://github.com/flint-lang/flintc";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zweiler1 ];
    mainProgram = "flintc";
    outputsToInstall = [ "out" ];
  };
})
