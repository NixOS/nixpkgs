{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "checkpwn";
  version = "0.6.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-RX3DCcCrZqv4REg+KGHOAXva8ta1PwvlXtS9MTFSlRo=";
  };

  cargoHash = "sha256-YIQbGOkW51KsO6vdqm8w1z4UDBmkpCUbvRIViE0a0KQ=";

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
