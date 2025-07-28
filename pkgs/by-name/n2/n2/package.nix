{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "n2";
  version = "0-unstable-2025-03-14";

  src = fetchFromGitHub {
    owner = "evmar";
    repo = "n2";
    rev = "d67d508c389ac2e6961c6f84cd668f05ec7dc7b7";
    hash = "sha256-eWcN/iK/ToufABi4+hIyWetp2I94Vy4INHb4r6fw+TY=";
  };

  cargoHash = "sha256-LTgAaTQXW0XEbe+WS47pqSb+eU7FqjdTSO2++C3J5aM=";

  meta = {
    homepage = "https://github.com/evmar/n2";
    description = "Ninja compatible build system";
    mainProgram = "n2";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
}
