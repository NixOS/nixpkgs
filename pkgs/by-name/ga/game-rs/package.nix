{
  lib,
  rustPlatform,
  fetchFromGitHub,
  umu-launcher,
}:

rustPlatform.buildRustPackage rec {
  pname = "game-rs";
  version = "5";

  src = fetchFromGitHub {
    owner = "amanse";
    repo = "game-rs";
    rev = "z${version}";
    hash = "sha256-+LQxU4jWBAOk+qHNvGxYXudX5dG6szQt3PiPI41Zxlo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-X9dWIeDKy3qLmFwUevN8ZUcwNVtt7Wnecbg7M6zUXFU=";

  propagatedBuildInputs = [ umu-launcher ];

  meta = with lib; {
    description = "Minimal CLI game launcher for linux";
    homepage = "https://github.com/amanse/game-rs";
    changelog = "https://github.com/Amanse/game-rs/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ amanse ];
    platforms = platforms.linux;
  };
}
