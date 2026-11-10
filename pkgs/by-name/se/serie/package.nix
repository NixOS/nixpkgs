{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  gitMinimal,
  serie,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "serie";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "serie";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OrCkF7l5hMPC0fyKvoRZZP8otKAFaQdUGQqjV//nx6c=";
  };

  cargoHash = "sha256-xDz2eZ3WAEEkzA2lim42oYIMtgAR3HuN9RdKHJ4s+HU=";

  nativeCheckInputs = [ gitMinimal ];

  passthru.tests.version = testers.testVersion { package = serie; };

  meta = {
    description = "Rich git commit graph in your terminal, like magic";
    homepage = "https://github.com/lusingander/serie";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "serie";
  };
})
