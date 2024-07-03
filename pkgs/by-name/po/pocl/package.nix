{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, cmake
, pkg-config
, hwloc
, llvmPackages_16
, lttng-ust
, ocl-icd
, python3
, runCommand
, makeWrapper
}:

let
  llvmPackages = llvmPackages_16;
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
        --add-flags "-L${stdenv.cc.cc.lib}/lib"
    done
  '';
in stdenv.mkDerivation (finalAttrs: {
  pname = "pocl";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "pocl";
    repo = "pocl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Uo4Np4io1s/NMK+twX36PLBFP0j5j/0NkkBvS2Zv9ng=";
  };

  cmakeFlags = [
    "-DKERNELLIB_HOST_CPU_VARIANTS=distro"
    # avoid the runtime linker pulling in a different llvm e.g. from graphics drivers
    "-DLLVM_STATIC=ON"
    "-DENABLE_POCL_BUILDING=OFF"
    "-DPOCL_ICD_ABSOLUTE_PATH=ON"
    "-DENABLE_ICD=ON"
    "-DCLANG=${clangWrapped}/bin/clang"
    "-DCLANGXX=${clangWrapped}/bin/clang++"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    clangWrapped
    python3
  ];

  buildInputs = [
    hwloc
    llvmPackages.llvm
    llvmPackages.libclang
    lttng-ust
    ocl-icd
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A portable open source (MIT-licensed) implementation of the OpenCL standard";
    homepage = "http://portablecl.org";
    license = licenses.mit;
    maintainers = with maintainers; [
      jansol
      xddxdd
    ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
