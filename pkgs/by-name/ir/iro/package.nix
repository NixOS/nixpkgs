{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "iro";
  version = "0-unstable-2024-10-24";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = "iro";
    rev = "ba4adc00e13da9086389357b0e92e608928a8b39";
    hash = "sha256-hGGrEGG1LyzfUCEnV7ahhRO0GrLk28xDWZEFqUHk1rE=";
  };

  cargoHash = "sha256-ZP0YO+5juxFGc2rtvNBvknlTJBrtr8HiuN6/kKW1WNU=";

  meta = {
    description = "CLI tool to convet Hex color code or RGB to color code, RGB, HSL and color name";
    homepage = "https://github.com/kyoheiu/iro";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
    mainProgram = "iro";
  };
}
