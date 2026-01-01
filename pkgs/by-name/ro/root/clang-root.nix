{
  stdenv,
  lib,
  fetchgit,
  apple-sdk,
  cmake,
  git,
<<<<<<< HEAD
  llvm_20,
=======
  llvm_18,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pkg-config,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "clang-root";
<<<<<<< HEAD
  version = "20-20250925-01";
=======
  version = "18-20250506-01";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchgit {
    url = "https://github.com/root-project/llvm-project";
    rev = "refs/tags/ROOT-llvm${version}";
<<<<<<< HEAD
    hash = "sha256-qEoQVv/Aw9gqKSNa8ZJGqPzwXvH1yXiSOkvrUWeXI+g=";
=======
    hash = "sha256-8tviNWNmvIJhxF4j9Z7zMnjltTX0Ka2fN9HIgLfNAco=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    git
  ];
  buildInputs = [
<<<<<<< HEAD
    llvm_20
=======
    llvm_18
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    "-DLLVM_MAIN_SRC_DIR=${llvm_20.src}"
=======
    "-DLLVM_MAIN_SRC_DIR=${llvm_18.src}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ]
  ++ (
    if stdenv.hostPlatform.isDarwin then
      [ "-DC_INCLUDE_DIRS=${apple-sdk.sdkroot}/usr/include" ]
    else
      lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${lib.getDev stdenv.cc.libc}/include"
  );
}
