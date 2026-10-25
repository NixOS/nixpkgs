{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "deploy-rs";
  version = "0-unstable-2026-10-07";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "45ba3f8c5cb28396fff71671806e2550b464ac86";
    hash = "sha256-TQiEqCAQ4bWppfeRGX4O3lwopsgsd2OvcOHTEQRRwEQ=";
  };

  cargoHash = "sha256-ONGMdmkKGPJ+6KF2hkZQBefkug/C5ZEqPidKR6OkCbU=";

  # Tests use the FSEvents API on macOS, which the darwin sandbox blocks by default
  sandboxProfile = ''
    (allow mach-lookup (global-name "com.apple.FSEvents"))
  '';

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
