{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  zlib,
  stdenv,
}:

# Used as a workaround for ucrtAarch64.
# compiler-rt due to pthread.h not being found during cross-build.

let
  version = "20260421";

  hostArch =
    if stdenv.hostPlatform.isAarch64 then
      "aarch64"
    else if stdenv.hostPlatform.isx86_64 then
      "x86_64"
    else
      throw "llvm-mingw: unsupported host platform ${stdenv.hostPlatform.system}";

  hashes = {
    aarch64 = "sha256-6c+lqTKQy4Utxaa5DM3iVUA6YzMmSL4XFHDKPBrTeCg=";
    x86_64 = "sha256-+LjM53mv/qtHvK7Gzm6edosWYJSjZhI+9kstCzicwSE=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "llvm-mingw-${hostArch}";
  inherit version;

  src = fetchurl {
    url = "https://github.com/mstorsjo/llvm-mingw/releases/download/${version}/llvm-mingw-${version}-ucrt-ubuntu-22.04-${hostArch}.tar.xz";
    hash = hashes.${hostArch};
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    (lib.getLib stdenv.cc.cc) # libstdc++
    zlib
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r * $out/

    runHook postInstall
  '';

  autoPatchelfIgnoreMissingDeps = [ "*.dll" ];
  dontStrip = true;

  meta = {
    description = "LLVM/Clang/LLD-based mingw-w64 toolchain (prebuilt)";
    homepage = "https://github.com/mstorsjo/llvm-mingw";
    license = lib.licenses.zlib;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
