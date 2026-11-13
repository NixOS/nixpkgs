{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "smfh";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "feel-co";
    repo = "smfh";
    tag = finalAttrs.version;
    hash = "sha256-uxC6yeXBMd6PtnZer0qBT9BnMf6hqFRp6rt5Row8yPM=";
  };

  cargoHash = "sha256-LN6z7YFo6rn5IibYU/MPjTBBszrUDJ7CKh/eV8obA3c=";

  meta = {
    description = "Sleek Manifest File Handler";
    homepage = "https://github.com/feel-co/smfh";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.feel-co ];
    mainProgram = "smfh";
  };
})
