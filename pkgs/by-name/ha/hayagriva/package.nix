{
  lib,
  rustPlatform,
  fetchCrate,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hayagriva";
  version = "0.10.1";

  src = fetchCrate {
    inherit (finalAttrs) version;
    pname = "hayagriva";
    hash = "sha256-bWCBKWuTyDoCQwzbqaHOD/1AZ/aNrwet1+E5iL6JcbA=";
  };

  cargoHash = "sha256-Dz7XmnIW3F2KV54jE1ZqqZLvUDJ88MfHn3tWoASeTkM=";

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
