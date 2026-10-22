{
  lib,
  rustPlatform,
  fetchFromGitHub,
  autoAddDriverRunpath,
  cudaPackages,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cuda-oxide";
  version = "0.2.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVlabs";
    repo = "cuda-oxide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dOa/ScWgEQre0f9MgxFVLRtuNcqr2JC61XP7FsHAP2A=";
  };

  cargoHash = "sha256-3JmDEO4DC9Xhgdoa0xnpUE9nJailezqoTUk6FA7BKeI=";

  nativeBuildInputs = [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
    rustPlatform.bindgenHook
  ];

  env = {
    # requires nightly features
    RUSTC_BOOTSTRAP = true;

    # Adding `cudaPackages.cuda_cudart` allows compilation to succeed, but cargo-oxide errors at runtime:
    #   cargo-oxide: error while loading shared libraries: libcuda.so.1: cannot open shared object file: No such file or directory
    CUDA_HOME = (lib.getLib cudaPackages.cuda_cudart).outPath;

    NIX_LDFLAGS = "-L${lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs"; # fixes -lcuda not found
  };

  cargoBuildFlags = [
    "--package=cargo-oxide"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Experimental Rust-to-CUDA compiler that lets you write (SIMT) GPU kernels in safe(ish), idiomatic Rust";
    homepage = "https://github.com/NVlabs/cuda-oxide";
    changelog = "https://github.com/NVlabs/cuda-oxide/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      ethancedwards8
    ];
    teams = with lib.teams; [ cuda ];
    mainProgram = "cargo-oxide";
  };
})
