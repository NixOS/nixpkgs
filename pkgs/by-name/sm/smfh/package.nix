{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "smfh";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "feel-co";
    repo = "smfh";
    tag = finalAttrs.version;
    hash = "sha256-mP/ln+GkafKSnK4LIrAZY45OZYErQFehHUKmBRhHJY4=";
  };

  cargoHash = "sha256-6kybKx2aZ0pTr0yXPawqTnJVntL1NNCkgEvRFQEwtCk=";

  meta = {
    description = "Sleek Manifest File Handler";
    homepage = "https://github.com/feel-co/smfh";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.feel-co ];
    mainProgram = "smfh";
  };
})
