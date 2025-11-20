{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
}:
let
  target = stdenv.hostPlatform.rust.cargoShortTarget;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bender";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "pulp-platform";
    repo = "bender";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RVVMQJpuNmGDJju7JXTyrBtqmiAp+e8a9+0mFSHMGJA=";
  };

  cargoHash = "sha256-VbLMSyy6PMP4aPMZg1EQMd7yrVWN9MRlRTIc3oP33HE=";

  nativeCheckInputs = [ gitMinimal ];
  postCheck = ''
    patchShebangs --build tests
    BENDER="target/${target}/$cargoBuildType/bender" tests/run_all.sh
  '';

  meta = {
    description = "Dependency management tool for hardware projects";
    homepage = "https://github.com/pulp-platform/bender";
    changelog = "https://github.com/pulp-platform/bender/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ Liamolucko ];
    mainProgram = "bender";
    platforms = lib.platforms.all;
  };
})
