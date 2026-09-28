{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cornucopia";
  version = "1.0.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cornucopia-rs";
    repo = "cornucopia";
    tag = "cornucopia-v${finalAttrs.version}";
    hash = "sha256-dmIodvHxnSgjLXFIzP6Oo2e/EOqkuT3JjMKZn0ka200=";
  };

  cargoHash = "sha256-kuxjjCNrjbmlbB6sCa9NHCV5ooC1SwqbasIe0Igottc=";

  cargoBuildFlags = [ "--package=cornucopia" ];

  cargoTestFlags = finalAttrs.cargoBuildFlags;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "cornucopia-v(.*)"
    ];
  };

  meta = {
    description = "Generate type-checked Rust from your PostgreSQL";
    homepage = "https://github.com/cornucopia-rs/cornucopia";
    changelog = "https://github.com/cornucopia-rs/cornucopia/blob/cornucopia-v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "cornucopia";
  };
})
