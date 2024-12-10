{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "minijinja";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "minijinja";
    rev = version;
    hash = "sha256-rRNikxSgr3isXkp/2oqPQ3JkugxuLgYlcT5c+4yIYBc=";
  };

  cargoHash = "sha256-ksdCvl8x6KfqNRnTeIKkL6nnr4d53wMv7pr2rupVkTI=";

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
