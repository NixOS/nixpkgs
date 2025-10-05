{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-rdme";
  version = "1.4.8";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-lVu9w8l3+SeqiMoQ8Bjoslf7tWz49jrrE4g/pDU1axI=";
  };

  cargoHash = "sha256-W800jepxDv6OjbcxRKphAnDU2OuBGGGSLELe8gAfTr8=";

  meta = {
    description = "Cargo command to create the README.md from your crate's documentation";
    mainProgram = "cargo-rdme";
    homepage = "https://github.com/orium/cargo-rdme";
    changelog = "https://github.com/orium/cargo-rdme/blob/v${version}/release-notes.md";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ GoldsteinE ];
  };
}
