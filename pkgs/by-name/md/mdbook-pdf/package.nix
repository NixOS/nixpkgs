{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pdf";
  version = "0.1.12";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-xlqRGYnbgQpba0uOc26GlkvTkXS1qbZ4p9okToF5sXU=";
  };

  cargoHash = "sha256-MOY+ETtfFdIdunp5nSOXLeOh4nuJ9YRPoCjQNKbco94=";

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
