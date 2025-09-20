{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "heh";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "ndd7xv";
    repo = "heh";
    rev = "v${version}";
    hash = "sha256-eqWBTylvXqGhWdSGHdTM1ZURSD5pkUBoBOvBJ5zmJ7w=";
  };

  cargoHash = "sha256-Sk/eL5Pza9L8GLBxqL9SqMT7KDWZenMjV+sGYaWUnzo=";

  meta = {
    description = "Cross-platform terminal UI used for modifying file data in hex or ASCII";
    homepage = "https://github.com/ndd7xv/heh";
    changelog = "https://github.com/ndd7xv/heh/releases/tag/${src.rev}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ piturnah ];
    mainProgram = "heh";
  };
}
