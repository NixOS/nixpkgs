{
  lib,
  fetchCrate,
  clippy,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "simit";
  version = "0.8.0";

  src = fetchCrate {
    pname = "simit";
    inherit (finalAttrs) version;
    hash = "sha256-NJou2R+K41JxMqXIbYwiHeoLuhflbN99ksVZgZTkb9I=";
  };

  cargoHash = "sha256-1BqrVbaa/Calo2T8ktIyYcmS765khQdqkabe7gv9cKw=";

  nativeCheckInputs = [
    clippy
    git
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Semver-aware git commit helper for Rust projects";
    homepage = "https://codeberg.org/caniko/simit";
    changelog = "https://codeberg.org/caniko/simit/src/tag/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caniko ];
    mainProgram = "simit";
  };
})
