{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,

  python3,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "biliup-rs";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "biliup";
    repo = "biliup-rs";
    tag = "v${version}";
    hash = "sha256-Gr2veeFDNHisqin4MQl/RcZN51BUHwTn7zUplP+VODo=";
  };

  nativeBuildInputs = [
    python3
    sqlite
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-7LiwKBsDAIc3zZvKFzgnIjup8lA70g7r7TtBCJ5VgL8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/biliup/biliup-rs/releases/tag/v${version}";
    description = "CLI tool for uploading videos to Bilibili";
    homepage = "https://biliup.github.io/biliup-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oosquare ];
    mainProgram = "biliup";
    platforms = lib.platforms.all;
  };
}
