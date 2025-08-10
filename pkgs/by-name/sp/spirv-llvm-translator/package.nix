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
  isROCm = lib.hasPrefix "rocm" llvm.pname;

  # ROCm, if actively updated will always be at the latest version
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
    "17" = rec {
      version = "17.0.15";
      rev = "v${version}";
      hash = "sha256-ETpTQYMMApECDfuRY87HrO/PUxZ13x9dBRJ3ychslUI=";
    };
    "16" = rec {
      version = "16.0.15";
      rev = "v${version}";
      hash = "sha256-30i73tGl+1KlP92XA0uxdMTydd9EtaQ4SZ0W1kdm1fQ=";
    };
    "15" = rec {
      version = "15.0.15";
      rev = "v${version}";
      hash = "sha256-kFVDS+qwoG1AXrZ8LytoiLVbZkTGR9sO+Wrq3VGgWNQ=";
    };
    "14" = rec {
      version = "14.0.14";
      rev = "v${version}";
      hash = "sha256-PW+5w93omLYPZXjRtU4BNY2ztZ86pcjgUQZkrktMq+4=";
    };
  };

  majorVersion = if isROCm then "21" else llvmMajor;
  branch = versions."${majorVersion}" or (throw "Incompatible LLVM version ${llvmMajor}");

  # For the LLVM 21 build some commits to spirv-headers
  # are required, that didn't make it into the final release of 1.4.321
  # For example: 9e3836d Add SPV_INTEL_function_variants
  # Once spirv-headers are released again and updated on nixpkgs,
  # this will switch over to the nixpkgs version once it exists,
  # at which point this can be removed.
  # In the meanwhile, we pull from the repo directly.
  spirv-headers-src =
    if majorVersion != "21" || lib.versionAtLeast spirv-headers.version "1.4.322" then
      spirv-headers.src
    else
      fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Headers";
        # Latest commit on main branch as of 2025-08-10
        rev = "a7361efd139bf65de0e86d43b01b01e0b34d387f";
        hash = "sha256-Z03gXioXxtUviAmOXmPLHB/QaW3DQUGyaSXiAQj5UE4=";
      };
in
stdenv.mkDerivation {
  pname = "SPIRV-LLVM-Translator";
  inherit (branch) version;

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-LLVM-Translator";
    inherit (branch) rev hash;
  };

  patches = lib.optionals (llvmMajor == "14") [
    (fetchpatch {
      # tries to install llvm-spirv into llvm nix store path
      url = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/commit/cce9a2f130070d799000cac42fe24789d2b777ab.patch";
      revert = true;
      hash = "sha256-GbFacttZRDCgA0jkUoFA4/B3EDn3etweKvM09OwICJ8=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ]
  ++ (if isROCm then [ llvm ] else [ llvm.dev ]);

  buildInputs = [
    spirv-headers
    spirv-tools
  ]
  ++ lib.optionals (!isROCm) [ llvm ];

  nativeCheckInputs = [ lit ];

  cmakeFlags = [
    "-DLLVM_INCLUDE_TESTS=ON"
    "-DLLVM_DIR=${(if isROCm then llvm else llvm.dev)}"
    "-DBUILD_SHARED_LIBS=YES"
    "-DLLVM_SPIRV_BUILD_EXTERNAL=YES"
    # RPATH of binary /nix/store/.../bin/llvm-spirv contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=${spirv-headers-src}"
  ]
  ++ lib.optional (llvmMajor == "19") "-DBASE_LLVM_VERSION=${lib.versions.majorMinor llvm.version}.0";

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
  };
}
