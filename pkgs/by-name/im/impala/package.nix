{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "impala";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "impala";
    rev = "v${version}";
    hash = "sha256-MrqyDwZztuYrqgbznBNDwusu3zNES+v2+BOti6lm5HU=";
  };

  cargoHash = "sha256-DBYQ7xeLLnIR5dcnvK2P4l5Fpfi/TvVajs4OQ66UUP0=";

  meta = {
    description = "TUI for managing wifi";
    homepage = "https://github.com/pythops/impala";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nydragon ];
  };
}
