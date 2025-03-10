{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "hayagriva";
  version = "0.8.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-JZfkYrb4Gn6oP+kcFj7kC10r1aSddigGZPRx18pr5Gg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2KlZTOp78HITJMRLNzw1bTUQSYeg5SmquRJWwwG3Xfw=";

  buildFeatures = [ "cli" ];

  checkFlags = [
    # requires internet access
    "--skip=try_archive"
    "--skip=always_archive"

    # requires a separate large repository
    "--skip=csl::tests::test_csl"
  ];

  meta = with lib; {
    description = "Work with references: Literature database management, storage, and citation formatting";
    homepage = "https://github.com/typst/hayagriva";
    changelog = "https://github.com/typst/hayagriva/releases/tag/v${version}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "hayagriva";
  };
}
