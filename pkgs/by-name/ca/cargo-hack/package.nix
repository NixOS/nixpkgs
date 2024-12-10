{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.32";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-XjubvjK+FySm0nqlzFsRhDQOI9M0enonwwPhZ/KFFlk=";
  };

  cargoHash = "sha256-sWXeGohH9iLMkmBgNjSfg25eDzZHSzWrOGgccuWPBLM=";

  # some necessary files are absent in the crate version
  doCheck = false;

  meta = with lib; {
    description = "Cargo subcommand to provide various options useful for testing and continuous integration";
    mainProgram = "cargo-hack";
    homepage = "https://github.com/taiki-e/cargo-hack";
    changelog = "https://github.com/taiki-e/cargo-hack/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
