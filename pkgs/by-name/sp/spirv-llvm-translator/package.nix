{
  lib,
  stdenv,
  srcOnly,
  fetchFromGitHub,
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
    "22" = rec {
      version = "22.1.7";
      rev = "v${version}";
      hash = "sha256-3yOvvT7cJ4Smz3aOJH6kh7CmfMNWaBAz6qxPnRA7zlE=";
    };
    "21" = rec {
      version = "21.1.12";
      rev = "v${version}";
      hash = "sha256-f/91YTqK3yBr/0oxceVKhJsDHj78T+Zt6Vf6iuiUpg4=";
    };
    "20" = rec {
      version = "20.1.18";
      rev = "v${version}";
      hash = "sha256-jVnNi5VOqWx8o6AuMfmenrncKUqvb/ii5xb6AhhQ9lE=";
    };
    "19" = rec {
      version = "19.1.23";
      rev = "v${version}";
      hash = "sha256-b1fbUuHYoeT14ixuSgLstGSBwb+cIm5O+a24/ydITF0=";
    };
    "18" = rec {
      version = "18.1.28";
      rev = "v${version}";
      hash = "sha256-JQQzbfZ0fVvEbjcmyFYZnzeXUjktOjWFpW6EsQykqr0=";
    };
  };

  branch =
    versions."${llvmMajor}" or {
      version = "${llvmMajor}.x.x";
      rev = "";
      hash = "";
    };
in
stdenv.mkDerivation {
  pname = "SPIRV-LLVM-Translator";
  inherit (branch) version;

  src = fetchFromGitHub {
    name = "spirv-llvm-translator-${branch.rev}-source";
    owner = "KhronosGroup";
    repo = "SPIRV-LLVM-Translator";
    inherit (branch) rev hash;
  };

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
    "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=${srcOnly spirv-headers}"
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

  meta = {
    homepage = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator";
    description = "Tool and a library for bi-directional translation between SPIR-V and LLVM IR";
    mainProgram = "llvm-spirv";
    license = lib.licenses.ncsa;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    broken = !(versions ? ${llvmMajor});
  };
}
