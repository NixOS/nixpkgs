{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "purefetch";
  version = "0.2.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ooonea";
    repo = "purefetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-twbeC5Glr3pLeJ/uO0TvdEcGbQvdGRyetV5oo+jXZT8=";
  };

  cargoHash = "sha256-kCT8izEcOVEGinyokeDH8ea3Qi5QEZPB+0R4tjkLpqg=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, fastfetch-style system information tool written entirely in Rust with zero dependencies";
    homepage = "https://github.com/ooonea/purefetch";
    changelog = "https://github.com/ooonea/purefetch/blob/v${finalAttrs.version}/CHANGELOG.md";
    license =
      with lib.licenses;
      AND [
        (OR [
          mit
          asl20
        ])
        cc-by-40
        cc-by-sa-30
        cc-by-sa-40
        gpl3Plus
      ];
    mainProgram = "purefetch";
    maintainers = with lib.maintainers; [ ooonea ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
