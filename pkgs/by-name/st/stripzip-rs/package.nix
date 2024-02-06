{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "stripzip-rs";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "TomaSajt";
    repo = "stripzip-rs";
    rev = "v${version}";
    hash = "sha256-uCHpnvbqFCs3g1ENxEwKspRuTH99QJGimZSo2XPiJGQ=";
  };

  cargoHash = "sha256-H/oKxRVpX5SIkGpQ0IKkVHpjLXRmGCUuNp9v+wjKQq8=";

  meta = {
    description = "A tool which removes metadata and unnecessary entries from ZIP archives.";
    homepage = "https://github.com/TomaSajt/stripzip-rs";
    license = lib.licenses.mit;
    mainProgram = "stripzip-rs";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
