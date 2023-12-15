{ lib
, rustPlatform
, fetchFromGitHub
, steam-run
}:

rustPlatform.buildRustPackage rec {
  pname = "game-rs";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "amanse";
    repo = "game-rs";
    rev = "v${version}";
    hash = "sha256-M9/hFItoCL8fSrc0dFNn43unqkIaD179OGUdbXL6/Rs=";
  };

  cargoHash = "sha256-aq58sFK4/Zd8S4dOWjag+g5PmTeaVAK3FS3fW/YlCLs=";

  buildFeatures = [ "nixos" ];

  propagatedBuildInputs = [ steam-run ];

  meta = with lib; {
    description = "Minimal CLI game launcher for linux";
    homepage = "https://github.com/amanse/game-rs";
    changelog = "https://github.com/Amanse/game-rs/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ amanse ];
    platforms = platforms.linux;
  };
}
