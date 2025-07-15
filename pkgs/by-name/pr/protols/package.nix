{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "protols";
  version = "0.12.7";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    tag = version;
    hash = "sha256-3XTFKqUPXW7Zm9IruePxq8uY1H/axuE1h22cqQj/YGg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-19CNMaDVI804ekxrmUjbx9WmqsG91rviLTsvFtN+D/o=";

  meta = {
    description = "Protocol Buffers language server written in Rust";
    homepage = "https://github.com/coder3101/protols";
    changelog = "https://github.com/coder3101/protols/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "protols";
  };
}
