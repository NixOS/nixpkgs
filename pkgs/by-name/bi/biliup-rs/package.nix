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
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "biliup";
    repo = "biliup-rs";
    tag = "v${version}";
    hash = "sha256-Zbl/d0LXwxHWyzfcLg+AMJrLXlXOf+aIzdNYHEvAd90=";
  };

  nativeBuildInputs = [
    python3
    sqlite
  ];

  cargoHash = "sha256-bSnc8xFFcWONFX35G3S75ppqA2WF/M0EB/68BR1AgWM=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/biliup/biliup-rs/releases/tag/v${version}";
    description = "CLI tool for uploading videos to Bilibili";
    homepage = "https://biliup.github.io/biliup-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "biliup";
    platforms = lib.platforms.all;
  };
}
