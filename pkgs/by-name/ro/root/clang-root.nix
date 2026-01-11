{
  stdenv,
  lib,
  fetchgit,
  apple-sdk,
  cmake,
  git,
  llvm_20,
  pkg-config,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "clang-root";
  version = "20-20250925-01";

  src = fetchgit {
    url = "https://github.com/root-project/llvm-project";
    rev = "refs/tags/ROOT-llvm${version}";
    hash = "sha256-qEoQVv/Aw9gqKSNa8ZJGqPzwXvH1yXiSOkvrUWeXI+g=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    git
  ];
  buildInputs = [
    llvm_20
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
    "-DLLVM_MAIN_SRC_DIR=${llvm_20.src}"
  ]
  ++ (
    if stdenv.hostPlatform.isDarwin then
      [ "-DC_INCLUDE_DIRS=${apple-sdk.sdkroot}/usr/include" ]
    else
      lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${lib.getDev stdenv.cc.libc}/include"
  );
}
