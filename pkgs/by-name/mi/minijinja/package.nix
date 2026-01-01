{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "minijinja";
<<<<<<< HEAD
  version = "2.14.0";
=======
  version = "2.12.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "minijinja";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-WPjhDj9Qlu38gWIX9ExwfL+OLoW8+RJZwKo1gfvUKn8=";
  };

  cargoHash = "sha256-Wvlw0djiQTT/JTWdnNivbpvFVOelWdCSHT3fxy2cdwE=";
=======
    hash = "sha256-R/bnJx0JygrcMvGDl2YBdGNziKBOds3azGj1IHzpU2Q=";
  };

  cargoHash = "sha256-SKnq/CbpPnUvjqWGt8Val/xKcqxpj7jCI4ABI8t4Lao=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # The tests relies on the presence of network connection
  doCheck = false;

  cargoBuildFlags = "--bin minijinja-cli";

  meta = {
    description = "Command Line Utility to render MiniJinja/Jinja2 templates";
    homepage = "https://github.com/mitsuhiko/minijinja";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ psibi ];
    changelog = "https://github.com/mitsuhiko/minijinja/blob/${version}/CHANGELOG.md";
    mainProgram = "minijinja-cli";
  };
}
