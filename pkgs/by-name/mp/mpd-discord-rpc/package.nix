{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "mpd-discord-rpc";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = "mpd-discord-rpc";
    rev = "v${version}";
    hash = "sha256-6PSwfvmGdcxQvmnbloTBWEiz5vbN/RxK4Afq1PgUX94=";
  };

  cargoHash = "sha256-ecGhzcaqvTDAvbeWkr/3uXu5GD3NqlgHAiywzHfmsaA=";

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
