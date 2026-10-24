{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "deploy-rs";
  version = "1.0.0-unstable-2026-10-19";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "1cec0527bd09074bbee6d4461900ce5d58267217";
    hash = "sha256-eINUtQW48bf9G3EYprthHMll8VDKxaXQP52TZFuwMmE=";
  };

  cargoHash = "sha256-bgx2aKAYtq/8A2fa8xlhSjh2Jd6Pas5rUF+IiYEoxXQ=";

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
