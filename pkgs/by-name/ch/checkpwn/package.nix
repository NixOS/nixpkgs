{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "checkpwn";
  version = "0.6.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-jQEg6wDZl2ar/KzhSPPpBRQ3JNThXk7j/zTbqeY6L58=";
  };

  cargoHash = "sha256-R7IGqZrnF/dsl94fuB4Z2hLdPozCWUZTCryFuSW89FQ=";

  # requires internet access
  checkFlags = [
    "--skip=test_cli_"
  ];

  meta = {
    description = "Check Have I Been Pwned and see if it's time for you to change passwords";
    homepage = "https://github.com/brycx/checkpwn";
    changelog = "https://github.com/brycx/checkpwn/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "checkpwn";
  };
})
