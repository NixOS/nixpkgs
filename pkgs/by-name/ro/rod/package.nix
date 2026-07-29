{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rod";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "leiserfg";
    repo = "rod";
    tag = finalAttrs.version;
    hash = "sha256-LwksGhz55CVY6D0IqNHA9OYNB6261xWxwxXxlYN5NQA=";
  };

  cargoHash = "sha256-vpZOS8PY9fSOVeMGQf8uYZtpUnc3D6a+ZenLmBCfPFg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for detecting the lightness of the terminal background";
    homepage = "https://github.com/leiserfg/rod";
    changelog = "https://github.com/leiserfg/rod/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      leiserfg
      nekowinston
    ];
    platforms = lib.platforms.unix;
  };
})
