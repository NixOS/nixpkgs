{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixf,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixf-diagnose";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "inclyc";
    repo = "nixf-diagnose";
    tag = finalAttrs.version;
    hash = "sha256-8kcA2/ZMREKtXUM5rlAWRQL/C8+JNocZegq2ZHqbiSA=";
  };

  env.NIXF_TIDY_PATH = lib.getExe nixf;

  cargoHash = "sha256-9rWQfoaMXFs83cYHtJPL0ogA9hPh7q3mK1DG4Q4CCq0=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI wrapper for nixf-tidy with fancy diagnostic output";
    mainProgram = "nixf-diagnose";
    homepage = "https://github.com/inclyc/nixf-diagnose";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ inclyc ];
  };
})
