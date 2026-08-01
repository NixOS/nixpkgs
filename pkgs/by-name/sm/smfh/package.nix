{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "smfh";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "feel-co";
    repo = "smfh";
    tag = finalAttrs.version;
    hash = "sha256-vKJWHujoGfTV61gjDglzu4ZMJ1phsUGNKELLEeF3QMg=";
  };

  cargoHash = "sha256-CvXZtq0o+cYrXP7FSBJLi23wtU9dsUOAOWDsht5cK+k=";

  meta = {
    description = "Sleek Manifest File Handler";
    homepage = "https://github.com/feel-co/smfh";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.feel-co ];
    mainProgram = "smfh";
  };
})
