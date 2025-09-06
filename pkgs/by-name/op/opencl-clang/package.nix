{
  lib,
  stdenv,
  applyPatches,
  callPackage,
  buildPackages,
  targetPackages,
  fetchFromGitHub,
  cmake,
  git,
  spirv-llvm-translator,
}:

let
  llvmPkgs =
    let
      llvmPkgs = callPackage ./llvm {
        buildLlvmTools = buildPackages.opencl-clang.llvmPkgs.tools;
        targetLlvmLibraries = targetPackages.opencl-clang.llvmPkgs.libraries or llvmPkgs.libraries;
        targetLlvm = targetPackages.opencl-clang.llvmPkgs.llvm or llvmPkgs.llvm;
        version = "15.0.7";
        sha256 = "sha256-wjuZQyXQ/jsmvy6y1aksCcEDXGBjuhpgngF3XQJ/T4s=";
      };
    in
    llvmPkgs;

  patchesOut = stdenv.mkDerivation {
    pname = "opencl-clang-patches";
    inherit version src;
    # Clang patches assume the root is the llvm root dir
    # but clang root in nixpkgs is the clang sub-directory
    postPatch = ''
      for filename in patches/clang/*.patch; do
        substituteInPlace "$filename" \
          --replace-fail "a/clang/" "a/" \
          --replace-fail "b/clang/" "b/"
      done
    '';

    installPhase = ''
      cp -r patches/ $out
      mkdir -p $out/clang $out/llvm
    '';
  };

  addPatches =
    component: pkg:
    pkg.overrideAttrs (oldAttrs: {
      postPatch = oldAttrs.postPatch or "" + ''
        for p in ${patchesOut}/${component}/*; do
          patch -p1 -i "$p"
        done
      '';
    });

  llvm = addPatches "llvm" llvmPkgs.tools.libllvm;
  spirv-llvm-translator' = spirv-llvm-translator.override { inherit llvm; };
  libclang = addPatches "clang" llvmPkgs.libclang;

  passthru = rec {
    inherit
      llvmPkgs
      llvm
      libclang
      patchesOut
      ;
    spirv-llvm-translator = spirv-llvm-translator';

    clang-unwrapped = libclang.out;
    clang = llvmPkgs.clang.override {
      cc = clang-unwrapped;
    };
  };

  version = "15.0.3";
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "intel";
      repo = "opencl-clang";
      tag = "v${version}";
      hash = "sha256-JkYFmnDh7Ot3Br/818aLN33COEG7+xyOf8OhdoJX9Cw=";
    };

    patches = [
      # Build script tries to find Clang OpenCL headers under ${llvm}
      # Work around it by specifying that directory manually.
      ./opencl-headers-dir.patch
    ];

    postPatch = ''
      # fix not be able to find clang from PATH
      substituteInPlace cl_headers/CMakeLists.txt \
        --replace-fail " NO_DEFAULT_PATH" ""
    '';
  };
in

stdenv.mkDerivation {
  pname = "opencl-clang";
  inherit version src;

  nativeBuildInputs = [
    cmake
    git
    llvm.dev
  ];

  buildInputs = [
    libclang
    llvm
    spirv-llvm-translator'
  ];

  cmakeFlags = [
    "-DPREFERRED_LLVM_VERSION=${lib.getVersion llvm}"
    "-DOPENCL_HEADERS_DIR=${lib.getLib libclang}/lib/clang/${lib.getVersion libclang}/include/"

    "-DLLVMSPIRV_INCLUDED_IN_LLVM=OFF"
    "-DSPIRV_TRANSLATOR_DIR=${spirv-llvm-translator'}"
  ];

  inherit passthru;

  meta = {
    homepage = "https://github.com/intel/opencl-clang/";
    description = "Clang wrapper library with an OpenCL-oriented API and the ability to compile OpenCL C kernels to SPIR-V modules";
    license = lib.licenses.ncsa;
    maintainers = [ lib.maintainers.SuperSandro2000 ];
    platforms = lib.platforms.linux;
  };
}
