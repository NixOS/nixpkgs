{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "deploy-rs";
  version = "0-unstable-2026-09-14";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "e760371d631165e7d8de5b0dcf148e21ec4c16f0";
    hash = "sha256-UXFQ7tFiwn8sPz0EV4CBB2PCf/ZiGIHWn/6MXk81Lxs=";
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
