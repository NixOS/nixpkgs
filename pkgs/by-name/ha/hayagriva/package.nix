{
  lib,
  rustPlatform,
  fetchCrate,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hayagriva";
  version = "0.9.1";

  src = fetchCrate {
    inherit (finalAttrs) version;
    pname = "hayagriva";
    hash = "sha256-9PGo/TPk5QuiVoa5wUGyHufW/VaxqhinxS+u2JMPZBY=";
  };

  cargoHash = "sha256-Ectd93B2yn/fn+N86LxGbUvtENsgjXTSCg06lHM8Xi0=";

  buildFeatures = [ "cli" ];

  checkFlags = [
    # requires internet access
    "--skip=try_archive"
    "--skip=always_archive"

    # requires a separate large repository
    "--skip=csl::tests::test_csl"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Work with references: Literature database management, storage, and citation formatting";
    homepage = "https://github.com/typst/hayagriva";
    changelog = "https://github.com/typst/hayagriva/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ trespaul ];
    mainProgram = "hayagriva";
  };
})
