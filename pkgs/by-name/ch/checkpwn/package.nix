{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "checkpwn";
  version = "0.6.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-QofPCfdOurEBGY1mwj5pQXtWA0+EJaEsjnHCXFjW1L8=";
  };

  cargoHash = "sha256-U5EXX8EzZC3uJ0cWzB5dT9sGDqIc9GsAbstts9PtjQ0=";

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
