{
  lib,
  stdenv,
  cmake,
  ninja,
  circt,
  llvm,
  python3,
  zstd,
}:
stdenv.mkDerivation {
  pname = circt.pname + "-llvm";
  inherit (circt) version src;

  requiredSystemFeatures = [ "big-parallel" ];

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    # This is needed for darwin builds
    zstd
  ];

  preConfigure = ''
    cd llvm/llvm
  '';

  cmakeFlags = [
    # Based on utils/build-llvm.sh
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "LLVM_BUILD_EXAMPLES" false)
    (lib.cmakeBool "LLVM_ENABLE_ASSERTIONS" true)
    (lib.cmakeBool "LLVM_ENABLE_BINDINGS" false)
    (lib.cmakeBool "LLVM_ENABLE_OCAMLDOC" false)
    (lib.cmakeFeature "LLVM_ENABLE_PROJECTS" "mlir")
    (lib.cmakeBool "LLVM_INSTALL_UTILS" true)
    (lib.cmakeBool "LLVM_INSTALL_GTEST" true)
    (lib.cmakeBool "LLVM_OPTIMIZED_TABLEGEN" true)
    (lib.cmakeFeature "LLVM_TARGETS_TO_BUILD" "host")
  ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  # Get rid of ${extra_libdir} (which ends up containing a path to circt-llvm.dev
  # in circt) so that we only have to remove the one fixed rpath.
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace llvm/llvm/cmake/modules/AddLLVM.cmake \
      --replace-fail 'set(_install_rpath "@loader_path/../lib''${LLVM_LIBDIR_SUFFIX}" ''${extra_libdir})' \
        'set(_install_rpath "@loader_path/../lib''${LLVM_LIBDIR_SUFFIX}")'
  '';

  postInstall = ''
    # move llvm-config to $dev to resolve a circular dependency
    moveToOutput "bin/llvm-config*" "$dev"

    # move all lib files to $lib except lib/cmake
    moveToOutput "lib" "$lib"
    moveToOutput "lib/cmake" "$dev"

    # patch configuration files so each path points to the new $lib or $dev paths
    substituteInPlace "$dev/lib/cmake/llvm/LLVMConfig.cmake" \
      --replace 'set(LLVM_BINARY_DIR "''${LLVM_INSTALL_PREFIX}")' 'set(LLVM_BINARY_DIR "'"$lib"'")'
    substituteInPlace \
      "$dev/lib/cmake/llvm/LLVMExports-release.cmake" \
      "$dev/lib/cmake/mlir/MLIRTargets-release.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/lib" "$lib/lib/lib" \
      --replace "\''${_IMPORT_PREFIX}/lib/objects-Release" "$lib/lib/objects-Release" \
      --replace "$out/bin/llvm-config" "$dev/bin/llvm-config" # patch path for llvm-config
  '';

  # Replace all references to @rpath with absolute paths and remove the rpaths.
  #
  # This is different from what the regular LLVM package does, which is to make
  # everything absolute from the start: however, that doesn't work for us because
  # we have `-DBUILD_SHARED_LIBS=ON`, meaning that many more things are
  # dynamically rather than statically linked. This includes TableGen, which then
  # fails to run halfway through the build because it tries to reference $lib when
  # it hasn't been populated yet.
  #
  # Inspired by fixDarwinDylibNames.
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    local flags
    for file in "$lib"/lib/*.dylib; do
      flags+=(-change @rpath/"$(basename "$file")" "$file")
    done

    for file in "$out"/bin/* "$lib"/lib/*.dylib; do
      if [ -L "$file" ]; then continue; fi
      if [[ "$file" == *.py ]]; then continue; fi
      echo "$file: fixing dylib references"
      # note that -id does nothing on binaries
      install_name_tool -id "$file" "''${flags[@]}" "$file"
    done
  '';

  # circt only use the mlir part of llvm, occasionally there are some unrelated failure from llvm,
  # disable the llvm check, but keep the circt check enabled.
  doCheck = false;
  checkTarget = "check-mlir";

  meta = llvm.meta // {
    inherit (circt.meta) maintainers;
  };
}
