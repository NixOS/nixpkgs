{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "jotdown";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "hellux";
    repo = "jotdown";
    rev = version;
    hash = "sha256-StlF+KjQ+UrKnZMuexwDhMI0ztFLsbexubx5s8Qtzho=";
  };

  cargoHash = "sha256-UroMKPDh0RbUu6oqjfbRkX6ZlKi5rJRVBu1apcJENyU=";

  meta = with lib; {
    description = "Minimal Djot CLI";
    mainProgram = "jotdown";
    homepage = "https://github.com/hellux/jotdown";
    changelog = "https://github.com/hellux/jotdown/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
