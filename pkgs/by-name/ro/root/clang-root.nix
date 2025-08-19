{
  stdenv,
  lib,
  fetchgit,
  apple-sdk,
  cmake,
  git,
  llvm_18,
  pkg-config,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "clang-root";
  version = "18-20250506-01";

  src = fetchgit {
    url = "https://github.com/root-project/llvm-project";
    rev = "refs/tags/ROOT-llvm${version}";
    hash = "sha256-8tviNWNmvIJhxF4j9Z7zMnjltTX0Ka2fN9HIgLfNAco=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    git
  ];
  buildInputs = [
    llvm_18
    python3
  ];

  patches = [
    ./Fix-find_package-LLVM-overwriting-LLVM_LINK_LLVM_DYLIB.patch
  ];

  preConfigure = ''
    cd clang
  '';

  cmakeFlags = [
    "-DCLANG_BUILD_TOOLS=OFF"
    "-DCLANG_ENABLE_ARCMT=OFF"
    "-DCLANG_ENABLE_STATIC_ANALYZER=OFF"
    "-DCLANG_LINK_CLANG_DYLIB=OFF"
    "-DC_INCLUDE_DIRS=${lib.getDev stdenv.cc.libc}/include"
    "-DLLVM_INCLUDE_TESTS=OFF"
    "-DLLVM_LINK_LLVM_DYLIB=OFF"
    "-DLLVM_MAIN_SRC_DIR=${llvm_18.src}"
  ]
  ++ (
    if stdenv.hostPlatform.isDarwin then
      [ "-DC_INCLUDE_DIRS=${apple-sdk.sdkroot}/usr/include" ]
    else
      lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${lib.getDev stdenv.cc.libc}/include"
  );
}
