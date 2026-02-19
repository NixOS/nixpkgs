{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pdf";
  version = "0.1.13";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-aADHRlIVWVc43DEfZx8ha/E4FaiAoKtjHccx+LAghtU=";
  };

  cargoHash = "sha256-aHpycw9WmaNsI0VAYxI89KnB7fC31FxH+8ONnMEGtTM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # Stop downloading from the Internet to
  # generate the Chrome Devtools Protocol
  env.DOCS_RS = true;

  # Stop formatting with rustfmt
  env.DO_NOT_FORMAT = true;

  # No test.
  doCheck = false;

  meta = {
    description = "Backend for mdBook written in Rust for generating PDF";
    mainProgram = "mdbook-pdf";
    homepage = "https://github.com/HollowMan6/mdbook-pdf";
    changelog = "https://github.com/HollowMan6/mdbook-pdf/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      hollowman6
      matthiasbeyer
    ];
  };
}
