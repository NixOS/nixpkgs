{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "minijinja";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "minijinja";
    rev = version;
    hash = "sha256-6jPTbtB7n85oGHYgOqZgBF5QyQGJwyZ3zyY+XLfU9y0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-V+ByJGJZFc1MEsSQkfO7P+08qDaTw0I2ye+4wwYrw4M=";

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
