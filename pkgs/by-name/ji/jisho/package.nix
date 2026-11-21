{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jisho";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "eagleflo";
    repo = "jisho";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EU0xJS01DNLleNEiwcs+f9EN6cQRnfxtFKelzPZptRE=";
  };

  cargoHash = "sha256-pkjLnfkiOitntFJ95RKoh/zGbPMHxv04o70QQV3aSDA=";

  __structuredAttrs = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool & Rust library that provides offline access to JMdict";
    homepage = "https://github.com/eagleflo/jisho";
    changelog = "https://github.com/eagleflo/jisho/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kangazero ];
    mainProgram = "jisho";
  };
})
