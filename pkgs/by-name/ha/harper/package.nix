{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "harper";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${version}";
    hash = "sha256-MwShWO1XXV2Ln70+w5KGPDChtnAOhsa2fENTNql3bo4=";
  };

  buildAndTestSubdir = "harper-ls";
  useFetchCargoVendor = true;
  cargoHash = "sha256-+rtFGD/go5W+RCpE0+3Tkb2TbwzH8J2nl0/VkipSjI0=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/Automattic/harper";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pbsds
      sumnerevans
    ];
    mainProgram = "harper-ls";
  };
}
