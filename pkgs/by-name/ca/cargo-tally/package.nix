{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.68";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-OJI0GDQqf15dFC9ckQDg43QQzowI5R6iMEMwfadzRZU=";
  };

  cargoHash = "sha256-UrMdyFcvBXsRJfIuDOKVIIkoOnwjJZPbAptusG8Tgwo=";

  meta = {
    description = "Graph the number of crates that depend on your crate over time";
    mainProgram = "cargo-tally";
    homepage = "https://github.com/dtolnay/cargo-tally";
    changelog = "https://github.com/dtolnay/cargo-tally/releases/tag/${version}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
