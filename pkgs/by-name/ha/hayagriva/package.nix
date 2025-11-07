{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "hayagriva";
  version = "0.9.1";

  src = fetchCrate {
    inherit pname version;
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

  meta = {
    description = "Work with references: Literature database management, storage, and citation formatting";
    homepage = "https://github.com/typst/hayagriva";
    changelog = "https://github.com/typst/hayagriva/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
    mainProgram = "hayagriva";
  };
}
