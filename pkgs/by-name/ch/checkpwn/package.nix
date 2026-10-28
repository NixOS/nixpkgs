{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "checkpwn";
  version = "0.6.3";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-EMSq4uK5pDZ3IhakTbKF2ljcIgOeLxydTMmBgwT2iCU=";
  };

  cargoHash = "sha256-O8EGkW4/OJzSsOG8E1SpdZT87kRc8WMt7Rn5OzzXZrM=";

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
