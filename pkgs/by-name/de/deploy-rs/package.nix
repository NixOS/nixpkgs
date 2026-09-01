{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "deploy-rs";
  version = "0-unstable-2026-07-31";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "b974715a27b49fadbf3bf6d85e26bcb3109daa6d";
    hash = "sha256-anlq3YQDCsNrkNlu3HTg4dEIpRugwnyAVUxoPcBmA/U=";
  };

  cargoHash = "sha256-ONGMdmkKGPJ+6KF2hkZQBefkug/C5ZEqPidKR6OkCbU=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Multi-profile Nix-flake deploy tool";
    homepage = "https://github.com/serokell/deploy-rs";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      teutat3s
      jk
    ];
    mainProgram = "deploy";
  };
}
