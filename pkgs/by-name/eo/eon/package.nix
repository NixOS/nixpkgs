{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "eon";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "emilk";
    repo = "eon";
    tag = finalAttrs.version;
    hash = "sha256-dsm4r3Or1QDA32VqERnak01vHcf7E8d/+F/S+lmMedA=";
  };

  cargoHash = "sha256-oaYykh2NtGPlDq5JSuCMaKmD65b1xZbeuGUDZD/STD0=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple and friendly config format";
    longDescription = ''
      The simple and friendly config format aimed to be a replacement
      for Toml and Yaml.
    '';
    homepage = "https://github.com/emilk/eon";
    changelog = "https://github.com/emilk/eon/blob/${finalAttrs.src.tag}/RELEASES.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "eon";
  };
})
