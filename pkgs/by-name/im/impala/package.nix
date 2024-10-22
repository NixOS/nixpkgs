{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "impala";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "impala";
    rev = "v${version}";
    hash = "sha256-4LQmM4VTW3ykh6eDWKxBe3jxlJphgAytgeaQZNwivsQ=";
  };

  cargoHash = "sha256-IMvlGAD9DB00luu9F4UKxwSYt0sV+IU8Pb7r10VtyYg=";

  meta = {
    description = "TUI for managing wifi";
    homepage = "https://github.com/pythops/impala";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nydragon ];
  };
}
