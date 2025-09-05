{
  lib,
  stdenv,
  llvm_meta,
  version,
  monorepoSrc,
  runCommand,
  cmake,
  ninja,
  python3,
  libllvm,
  libxcrypt,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "compiler-rt-libc";
  inherit version;

  src = runCommand "compiler-rt-src-${version}" { inherit (monorepoSrc) passthru; } (''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/compiler-rt "$out"
  '');

  sourceRoot = "${finalAttrs.src.name}/compiler-rt";

  patches =

    [
      ./X86-support-extension.patch # Add support for i486 i586 i686 by reusing i386 config
      # ld-wrapper dislikes `-rpath-link //nix/store`, so we normalize away the
      # extra `/`.
      ./normalize-var.patch
      # Fix build on armv6l
      ./armv6-no-ldrexd-strexd.patch
      ./gnu-install-dirs.patch
      (fetchpatch {
        name = "cfi_startproc-after-label.patch";
        url = "https://github.com/llvm/llvm-project/commit/7939ce39dac0078fef7183d6198598b99c652c88.patch";
        stripLen = 1;
        hash = "sha256-tGqXsYvUllFrPa/r/dsKVlwx5IrcJGccuR1WAtUg7/o=";
      })
      # Prevent a compilation error on darwin
      ./darwin-targetconditionals.patch
      # See: https://github.com/NixOS/nixpkgs/pull/186575
      ./darwin-plistbuddy-workaround.patch
      # See: https://github.com/NixOS/nixpkgs/pull/194634#discussion_r999829893
      ./armv7l-15.patch
      # Fix build on armv6l
      ./armv6-scudo-no-yield.patch
      ./armv6-scudo-libatomic.patch
    ];

  nativeBuildInputs = [
    cmake
    python3
    libllvm.dev
    ninja
  ];

  env = {
    NIX_CFLAGS_COMPILE = "-DSCUDO_DEFAULT_OPTIONS=DeleteSizeMismatch=0:DeallocationTypeMismatch=0";
    # Just here to not trigger a rebuild
    NIX_CFLAGS_LINK = "";
  };

  cmakeFlags = [
    (lib.cmakeBool "COMPILER_RT_DEFAULT_TARGET_ONLY" true)
    (lib.cmakeFeature "CMAKE_C_COMPILER_TARGET" stdenv.hostPlatform.config)
    (lib.cmakeFeature "CMAKE_ASM_COMPILER_TARGET" stdenv.hostPlatform.config)
    (lib.cmakeFeature "SANITIZER_COMMON_CFLAGS" "-I${libxcrypt}/include")
  ];

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    substituteInPlace cmake/builtin-config-ix.cmake \
      --replace-fail 'set(X86 i386)' 'set(X86 i386 i486 i586 i686)'
  '';

  # Just here to not trigger a rebuild
  preConfigure = "";
  postInstall = "";

  meta = llvm_meta // {
    homepage = "https://compiler-rt.llvm.org/";
    description = "Compiler runtime libraries";
    longDescription = ''
      The compiler-rt project provides highly tuned implementations of the
      low-level code generator support routines like "__fixunsdfdi" and other
      calls generated when a target doesn't have a short sequence of native
      instructions to implement a core IR operation. It also provides
      implementations of run-time libraries for dynamic testing tools such as
      AddressSanitizer, ThreadSanitizer, MemorySanitizer, and DataFlowSanitizer.
    '';
    # "All of the code in the compiler-rt project is dual licensed under the MIT
    # license and the UIUC License (a BSD-like license)":
    license = with lib.licenses; [
      mit
      ncsa
    ];
  };
})
