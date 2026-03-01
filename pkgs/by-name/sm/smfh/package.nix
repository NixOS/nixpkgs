{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "smfh";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "feel-co";
    repo = "smfh";
    tag = finalAttrs.version;
    hash = "sha256-6zMgOPzBbTSm8jzPqmGcotjvkN3HzxcnMM8pW64JpZQ=";
  };

  cargoHash = "sha256-FVTpH+scBCjgm3sf9sowRCI/X2jCS1wHtLLiOyKAD8U=";

  meta = {
    description = "Sleek Manifest File Handler";
    homepage = "https://github.com/feel-co/smfh";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.feel-co ];
    mainProgram = "smfh";
  };
})
