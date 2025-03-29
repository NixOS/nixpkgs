{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "minijinja";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "minijinja";
    rev = version;
    hash = "sha256-U/cncTfMyEvJbD+pr4kUxHcdsf9BxnMcL5bNvE8ard4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Pbb2cq7IEA1ZqWnHoOtIRgBDXf6GjT7G8plswlWG2Ko=";

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
