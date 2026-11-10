{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deploy-rs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i5dTwfPglZYE1zpg2IvBq+n0wDxMdrLwgHuRxZmO6Tw=";
  };

  cargoHash = "sha256-bgx2aKAYtq/8A2fa8xlhSjh2Jd6Pas5rUF+IiYEoxXQ=";

  # Tests use the FSEvents API on macOS, which the darwin sandbox blocks by default
  sandboxProfile = ''
    (allow mach-lookup (global-name "com.apple.FSEvents"))
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-profile Nix-flake deploy tool";
    homepage = "https://github.com/serokell/deploy-rs";
    changelog = "https://github.com/serokell/deploy-rs/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      teutat3s
      jk
    ];
    mainProgram = "deploy";
  };
})
