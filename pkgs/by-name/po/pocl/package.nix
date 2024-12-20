{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  hwloc,
  llvmPackages,
  libxml2, # required for statically linked llvm
  spirv-llvm-translator,
  spirv-tools,
  lttng-ust,
  ocl-icd,
  python3,
  runCommand,
  makeWrapper,
}:

let
  clang = llvmPackages.clangUseLLVM;
  # Workaround to make sure libclang finds libgcc.a and libgcc_s.so when
  # invoked from within libpocl
  clangWrapped = runCommand "clang-pocl" { nativeBuildInputs = [ makeWrapper ]; } ''
    mkdir -p $out/bin
    cp -r ${clang}/bin/* $out/bin/
    LIBGCC_DIR=$(dirname $(find ${stdenv.cc.cc}/lib/ -name libgcc.a))
    for F in ${clang}/bin/ld*; do
      BASENAME=$(basename "$F")
      rm -f $out/bin/$BASENAME
      makeWrapper ${clang}/bin/$BASENAME $out/bin/$BASENAME \
        --add-flags "-L$LIBGCC_DIR" \
        --add-flags "-L${lib.getLib stdenv.cc.cc}/lib"
    done
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pocl";
  version = "6.0";

  src = fetchFromGitHub {
    owner = "pocl";
    repo = "pocl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NHR9yrI6Odb/s/OBnEVifdcLEXvwqzAMZWpGViv2cJg=";
  };

  cmakeFlags = [
    "-DKERNELLIB_HOST_CPU_VARIANTS=distro"
    # avoid the runtime linker pulling in a different llvm e.g. from graphics drivers
    "-DSTATIC_LLVM=ON"
    "-DENABLE_POCL_BUILDING=OFF"
    "-DPOCL_ICD_ABSOLUTE_PATH=ON"
    "-DENABLE_ICD=ON"
    "-DCLANG=${clangWrapped}/bin/clang"
    "-DCLANGXX=${clangWrapped}/bin/clang++"
    "-DENABLE_REMOTE_CLIENT=ON"
    "-DENABLE_REMOTE_SERVER=ON"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    clangWrapped
    python3
  ];

  buildInputs = [
    hwloc
    libxml2
    llvmPackages.llvm
    llvmPackages.libclang
    lttng-ust
    ocl-icd
    spirv-tools
    spirv-llvm-translator
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A portable open source (MIT-licensed) implementation of the OpenCL standard";
    homepage = "http://portablecl.org";
    changelog = "https://github.com/pocl/pocl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jansol
      xddxdd
    ];
    platforms = lib.platforms.unix;
  };
})
