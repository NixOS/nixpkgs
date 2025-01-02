{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "hayagriva";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-B0q5jwJVDpxywTuSspsfDameDfEkok5oTz/Oty9LkOI=";
  };

  cargoHash = "sha256-N+3W4x5p5qas47uwVT0NrJNe9udE+0rQLx/ypo1pbR4=";

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
