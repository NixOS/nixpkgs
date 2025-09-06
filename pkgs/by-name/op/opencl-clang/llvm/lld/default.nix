{
  lib,
  stdenv,
  llvm_meta,
  buildLlvmTools,
  monorepoSrc,
  runCommand,
  cmake,
  ninja,
  libxml2,
  libllvm,
  version,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lld";
  inherit version;

  src = runCommand "lld-src-${version}" { inherit (monorepoSrc) passthru; } ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/lld "$out"
    mkdir -p "$out/libunwind"
    cp -r ${monorepoSrc}/libunwind/include "$out/libunwind"
    mkdir -p "$out/llvm"
  '';

  sourceRoot = "${finalAttrs.src.name}/lld";

  patches = [
    ./gnu-install-dirs.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];
  buildInputs = [
    libllvm
    libxml2
  ];

  cmakeFlags = [
    (lib.cmakeFeature "LLD_INSTALL_PACKAGE_DIR" "${placeholder "dev"}/lib/cmake/lld")
    (lib.cmakeFeature "LLVM_TABLEGEN_EXE" "${buildLlvmTools.tblgen}/bin/llvm-tblgen")
  ];

  # Just here to not trigger a rebuild
  postPatch = "";
  LDFLAGS = "";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  meta = llvm_meta // {
    homepage = "https://lld.llvm.org/";
    description = "LLVM linker (unwrapped)";
    longDescription = ''
      LLD is a linker from the LLVM project that is a drop-in replacement for
      system linkers and runs much faster than them. It also provides features
      that are useful for toolchain developers.
      The linker supports ELF (Unix), PE/COFF (Windows), Mach-O (macOS), and
      WebAssembly in descending order of completeness. Internally, LLD consists
      of several different linkers.
    '';
  };
})
