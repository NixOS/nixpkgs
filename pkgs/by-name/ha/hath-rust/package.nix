{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hath-rust";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "james58899";
    repo = "hath-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bo9MXMk/Dfa8cXjeWn14MF6rmVcWYes0WeVn1oC2y0k=";
  };

  cargoHash = "sha256-4xty4nUs81nq2Ax7koFplHlscpG1Pdbd5zwd/lQwbmg=";

  # TODO: Remove once Rust 1.91 is merged into master.
  #       See: https://github.com/NixOS/nixpkgs/pull/457185
  env.RUSTC_BOOTSTRAP = 1;
  patches = [ ./nightly-feature.patch ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unofficial Hentai@Home client written in Rust";
    homepage = "https://github.com/james58899/hath-rust";
    changelog = "https://github.com/james58899/hath-rust/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "hath-rust";
  };
})
