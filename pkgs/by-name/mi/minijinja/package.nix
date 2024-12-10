{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "minijinja";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "minijinja";
    rev = version;
    hash = "sha256-8ZAc5ALhpPyFCCsC0f22fSZKRmevFLLFFC0drUuXxg4=";
  };

  cargoHash = "sha256-2aeRb5jNZbpzAgpne494BMr7rkDqZUJEpITtHbdmhxY=";

  # The tests relies on the presence of network connection
  doCheck = false;

  cargoBuildFlags = "--bin minijinja-cli";

  meta = with lib; {
    description = "Command Line Utility to render MiniJinja/Jinja2 templates";
    homepage = "https://github.com/mitsuhiko/minijinja";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ psibi ];
    changelog = "https://github.com/mitsuhiko/minijinja/blob/${version}/CHANGELOG.md";
    mainProgram = "minijinja-cli";
  };
}
