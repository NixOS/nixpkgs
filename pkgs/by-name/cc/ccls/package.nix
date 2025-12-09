{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  rapidjson,
  runtimeShell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ccls";
  version = "0.20250815.1";

  src = fetchFromGitHub {
    owner = "MaskRay";
    repo = "ccls";
    tag = finalAttrs.version;
    hash = "sha256-3Wi8hsjFtFa0/HCZtli2omOskIlxV7FndbJv9MOWhMo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    llvmPackages.clang
    llvmPackages.llvm.dev
  ];
  buildInputs = [
    llvmPackages.libclang
    llvmPackages.llvm
    rapidjson
  ];

  cmakeFlags = [ "-DCCLS_VERSION=${finalAttrs.version}" ];

  preConfigure = ''
    cmakeFlagsArray+=(-DCMAKE_CXX_FLAGS="-fvisibility=hidden -fno-rtti")
  '';

  postFixup = ''
    export wrapped=".ccls-wrapped"
    mv $out/bin/ccls $out/bin/$wrapped
    substitute ${./wrapper} $out/bin/ccls \
      --replace-fail '@clang@' '${llvmPackages.clang}' \
      --replace-fail '@shell@' '${runtimeShell}' \
      --replace-fail '@wrapped@' "$wrapped"
    chmod --reference=$out/bin/$wrapped $out/bin/ccls
  '';

  meta = {
    description = "C/c++ language server powered by clang";
    mainProgram = "ccls";
    homepage = "https://github.com/MaskRay/ccls";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [
      lib.maintainers.mic92
      lib.maintainers.tobim
    ];
  };
})
