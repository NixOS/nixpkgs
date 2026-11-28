{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "checkpwn";
  version = "0.6.4";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-3aXyLu4HxYHLS2gqbe5RV031WEEoz5hYVD4Mt0HuV0w=";
  };

  cargoHash = "sha256-ToXUkX1biXlxeymuoi/007eZgqWZO58Yn24Sq8UU6Uc=";

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
