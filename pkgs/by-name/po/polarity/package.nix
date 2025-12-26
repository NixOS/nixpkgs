{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-12-17";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "54db456e28778d98d78d671868bfd58b34da18c2";
    hash = "sha256-YQAU8flTL5Yr9ZZYe2GWwtYWKLPmB+TXZ1JHVnAmJds=";
  };

  cargoHash = "sha256-sOnlMAdDB1RVMQGyCD4mNa7EV++PeKrD5dDK1hG9VkM=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Language with Dependent Data and Codata Types";
    homepage = "https://polarity-lang.github.io/";
    changelog = "https://github.com/polarity-lang/polarity/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "pol";
    platforms = lib.platforms.all;
  };
}
