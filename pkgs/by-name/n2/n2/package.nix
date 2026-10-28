{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "n2";
  version = "0-unstable-2025-11-10";

  src = fetchFromGitHub {
    owner = "evmar";
    repo = "n2";
    rev = "b1fead52ccda0c497d816696f23f4099c3e8ec1f";
    hash = "sha256-9nS/0QrdKeR8uzcKVu8T5pNp/FX5fGmOM/BRLChTR20=";
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
