{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "mpd-discord-rpc";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = "mpd-discord-rpc";
    rev = "v${version}";
    hash = "sha256-RuXH0RaR0VVN7tja0pcc8QH826/JzH4tyVVCbrK7ldI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ewmg5t0JljnvxjrGDJzokRwndv7UNw9NMQ7Cx6oDWjg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Rust application which displays your currently playing song / album / artist from MPD in Discord using Rich Presence";
    homepage = "https://github.com/JakeStanger/mpd-discord-rpc/";
    changelog = "https://github.com/JakeStanger/mpd-discord-rpc/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
    mainProgram = "mpd-discord-rpc";
  };
}
