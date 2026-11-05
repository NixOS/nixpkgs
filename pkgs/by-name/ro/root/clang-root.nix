{
  stdenv,
  lib,
  fetchFromGitHub,
  apple-sdk,
  cmake,
  llvm_22,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clang-root";
  version = "22-20261028-01";

  src = fetchFromGitHub {
    owner = "root-project";
    repo = "llvm-project";
    tag = "ROOT-llvm${finalAttrs.version}";
    hash = "sha256-Zp/I/sT0cfW2N/VobE5yX5XCDUnP/s5hjn4W7QFR+AM=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];
  buildInputs = [
    llvm_22
  ];

  preConfigure = ''
    cd clang
  '';

  cmakeFlags = [
    "-DCLANG_BUILD_TOOLS=OFF"
    "-DCLANG_ENABLE_ARCMT=OFF"
    "-DCLANG_ENABLE_STATIC_ANALYZER=OFF"
    "-DCLANG_LINK_CLANG_DYLIB=OFF"
    "-DLLVM_INCLUDE_TESTS=OFF"
    "-DLLVM_LINK_LLVM_DYLIB=OFF"
    "-DLLVM_MAIN_SRC_DIR=${llvm_22.src}"
  ]
  ++ (
    if stdenv.hostPlatform.isDarwin then
      [ "-DC_INCLUDE_DIRS=${apple-sdk.sdkroot}/usr/include" ]
    else
      lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${lib.getDev stdenv.cc.libc}/include"
  );

  meta = {
    description = "Clang with the patches required by ROOT's C++ interpreter";
    homepage = "https://github.com/root-project/llvm-project";
    # Same as for the LLVM packages in nixpkgs
    license =
      with lib.licenses;
      AND [
        ncsa
        (WITH asl20 llvm-exception)
      ];
    platforms = lib.platforms.unix;
    maintainers = [
      lib.maintainers.guitargeek
      lib.maintainers.veprbl
    ];
  };
})
