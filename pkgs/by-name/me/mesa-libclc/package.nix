{
  lib,
  stdenv,
  fetchFromGitLab,
  buildEnv,
  cmake,
  llvmPackages_22,
  mesa,
  spirv-llvm-translator,
}:
let
  spirv-llvm-translator' = spirv-llvm-translator.override {
    inherit (llvmPackages_22) llvm;
  };
  tools = buildEnv {
    name = "mesa-libclc-tools";
    paths = [
      llvmPackages_22.clang-unwrapped
      llvmPackages_22.llvm
    ];
    pathsToLink = [ "/bin" ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mesa-libclc";
  version = "22.1.8.3";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "karolherbst";
    repo = "mesa-libclc";
    tag = finalAttrs.version;
    hash = "sha256-YQkVgI5vfQsjf07z5bJ9FCm85TsX7SN2ODEitIB46zg=";
  };

  nativeBuildInputs = [
    cmake
    spirv-llvm-translator'
  ];

  buildInputs = [
    llvmPackages_22.llvm
  ];

  cmakeFlags = [
    "-DLIBCLC_CUSTOM_LLVM_TOOLS_BINARY_DIR=${tools}/bin"
  ];

  meta = {
    description = "Mesa fork of libclc, for use with Rusticl";
    homepage = "https://gitlab.freedesktop.org/karolherbst/mesa-libclc";
    changelog = "https://gitlab.freedesktop.org/karolherbst/mesa-libclc/-/releases/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    inherit (mesa.meta) maintainers platforms;
  };
})
