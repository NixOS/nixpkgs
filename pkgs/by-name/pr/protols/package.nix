{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "protols";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    rev = "refs/tags/${version}";
    hash = "sha256-oxcC+PRQ+gyYyg5r9C3N7lP8ZJj+8sqJMA+Ovoxq+P4=";
  };

  cargoHash = "sha256-rrurR/3OgjaAAq5Z9RTFOC6j13eBI34+z+aTLQkKjV4=";

  meta = {
    description = "Protocol Buffers language server written in Rust";
    homepage = "https://github.com/coder3101/protols";
    changelog = "https://github.com/coder3101/protols/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "protols";
  };
}
