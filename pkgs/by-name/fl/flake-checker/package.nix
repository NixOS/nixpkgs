{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flake-checker";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "flake-checker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-J0RAJJdpKYgMeV8+aojCRKVkXWa4PzdaAJHLjZInB4E=";
  };

  cargoHash = "sha256-8iHYK8Pf1P4TlfCkFVMeco/sldzAU40jLfod1qcucPg=";

  meta = {
    description = "Health checks for your Nix flakes";
    homepage = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}";
    changelog = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lucperkins ];
    mainProgram = "flake-checker";
  };
})
