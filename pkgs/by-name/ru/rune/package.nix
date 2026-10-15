{
  lib,
  rustPlatform,
  fetchCrate,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rune";
  version = "0.14.2";

  src = fetchCrate {
    pname = "rune-cli";
    inherit (finalAttrs) version;
    hash = "sha256-f/kpdDrLQLuKrOTV+AkxzbzBBLIW6j+RAERn5YIUSL4=";
  };

  cargoHash = "sha256-l/RlOi7DVLNlqAb5M0pvU7Eks3xmhmOgmkLFvoGyMLs=";

  env = {
    RUNE_VERSION = finalAttrs.version;
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interpreter for the Rune Language, an embeddable dynamic programming language for Rust";
    homepage = "https://rune-rs.github.io/";
    changelog = "https://github.com/rune-rs/rune/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "rune";
  };
})
