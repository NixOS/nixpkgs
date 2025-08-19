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
    "19" = rec {
      version = "19.1.6";
      rev = "v${version}";
      hash = "sha256-mUvDF5y+cBnqUaHjyiiE8cJGH5MfQMqGFy6bYv9vCVY=";
    };
    "18" = rec {
      version = "18.1.11";
      rev = "v${version}";
      hash = "sha256-VoALyFqShKL3bpeoOIdKoseNfDWiRE+j0ppHapXOmEU=";
    };
    "17" = rec {
      version = "17.0.11";
      rev = "v${version}";
      hash = "sha256-Ba4GZS7Rc93Fphj2xaBZ3AqwXvxB9UU0gzPNoDEoaQM=";
    };
    "16" = rec {
      version = "16.0.11";
      rev = "v${version}";
      hash = "sha256-PI4cT/PGqpaF5SysOTrEE4D+OcIUsIOMzww4CRPtwBQ=";
    };
    "15" = rec {
      version = "15.0.13";
      rev = "v${version}";
      hash = "sha256-RnGbBHUUGjIBcakQJO4nAm3/oIrQ8nkx+BC8Evw6Jmc=";
    };
    "14" = {
      version = "14.0.11+unstable-2025-01-28";
      rev = "9df26b6af308cb834a4013deb8094f386f29accd";
      hash = "sha256-8VRQwXFbLcYgHtWKs73yuTsy2kkCgYgPqD+W/GPy1BM=";
    };
  };

  branch =
    versions."${if isROCm then "17" else llvmMajor}"
      or (throw "Incompatible LLVM version ${llvmMajor}");
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
    "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=${spirv-headers.src}"
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
