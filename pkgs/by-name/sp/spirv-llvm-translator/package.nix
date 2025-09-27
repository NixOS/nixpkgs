{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  lit,
  llvm,
  spirv-headers,
  spirv-tools,
  pkgs,
}:

let
  llvmMajor = lib.versions.major llvm.version;

  versions = {
    "21" = rec {
      version = "21.1.0";
      rev = "v${version}";
      hash = "sha256-kk8BbPl/UBW1gaO/cuOQ9OsiNTEk0TkvRDLKUAh6exk=";
    };
    "20" = rec {
      version = "20.1.5";
      rev = "v${version}";
      hash = "sha256-GdlC/Vl61nTNdua2s+CW2YOvkSKK6MNOvBc/393iths=";
    };
    "19" = rec {
      version = "19.1.10";
      rev = "v${version}";
      hash = "sha256-VgA47AGMnOKYNeW95nxJZzmKnYK8D/9okgssPnPqXXI=";
    };
    "18" = rec {
      version = "18.1.15";
      rev = "v${version}";
      hash = "sha256-rt3RTZut41uDEh0YmpOzH3sOezeEVWtAIGMKCHLSJBw=";
    };
  };

  branch = versions."${llvmMajor}" or (throw "Incompatible LLVM version ${llvmMajor}");
in
stdenv.mkDerivation {
  pname = "SPIRV-LLVM-Translator";
  inherit (branch) version;

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-LLVM-Translator";
    inherit (branch) rev hash;
  };

  # TODO: Remove.
  patches = [ ];

  nativeBuildInputs = [
    pkg-config
    cmake
    llvm.dev
  ];

  buildInputs = [
    spirv-headers
    spirv-tools
    llvm
  ];

  nativeCheckInputs = [ lit ];

  cmakeFlags = [
    "-DLLVM_INCLUDE_TESTS=ON"
    "-DLLVM_DIR=${llvm.dev}"
    "-DBUILD_SHARED_LIBS=YES"
    "-DLLVM_SPIRV_BUILD_EXTERNAL=YES"
    # RPATH of binary /nix/store/.../bin/llvm-spirv contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=${spirv-headers.src}"
  ]
  ++ lib.optional (
    lib.toInt llvmMajor >= 19
  ) "-DBASE_LLVM_VERSION=${lib.versions.majorMinor llvm.version}.0";

  # FIXME: CMake tries to run "/llvm-lit" which of course doesn't exist
  doCheck = false;

  makeFlags = [
    "all"
    "llvm-spirv"
  ];

  postInstall = ''
    install -D tools/llvm-spirv/llvm-spirv $out/bin/llvm-spirv
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool $out/bin/llvm-spirv \
      -change @rpath/libLLVMSPIRVLib.dylib $out/lib/libLLVMSPIRVLib.dylib
  '';

  passthru.tests = lib.genAttrs (lib.attrNames versions) (
    version: pkgs.spirv-llvm-translator.override { llvm = pkgs."llvm_${version}"; }
  );

  meta = with lib; {
    homepage = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator";
    description = "Tool and a library for bi-directional translation between SPIR-V and LLVM IR";
    mainProgram = "llvm-spirv";
    license = licenses.ncsa;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gloaming ];

    # For the LLVM 21 build some commits to spirv-headers
    # are required that didn't make it into the final release of 1.4.321
    # For example: 9e3836d Add SPV_INTEL_function_variants
    # Once spirv-headers are released again and updated on nixpkgs,
    # this will switch over to the nixpkgs version and should no
    # longer be broken.
    broken = llvmMajor == "21" && lib.versionOlder spirv-headers.version "1.4.322";
  };
}
