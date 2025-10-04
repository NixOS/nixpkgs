{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "hayagriva";
  version = "0.9.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-0zNXQAqVkjSGFblq3mNP8AdCOxwBcgkNSH8fwRZ46yI=";
  };

  cargoHash = "sha256-N5GrMBXUY+eZad0coaLNzyD3ZEZdFDfZHuKoIqvH1Zg=";

  buildFeatures = [ "cli" ];

  checkFlags = [
    # requires internet access
    "--skip=try_archive"
    "--skip=always_archive"

    # requires a separate large repository
    "--skip=csl::tests::test_csl"
  ];

  meta = {
    description = "Work with references: Literature database management, storage, and citation formatting";
    homepage = "https://github.com/typst/hayagriva";
    changelog = "https://github.com/typst/hayagriva/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "hayagriva";
  };
}
