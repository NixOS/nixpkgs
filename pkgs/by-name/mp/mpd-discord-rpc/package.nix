{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mpd-discord-rpc";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = "mpd-discord-rpc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vP6d5HxlfLSIobWm7h34ttHjzpx+UZKE6Iyj9QfTRl0=";
  };

  cargoHash = "sha256-Pw/Y3STSzOtgWYu1OnmdV2Ybxl1WuIwqfGKbmRruR7w=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "Rust application which displays your currently playing song / album / artist from MPD in Discord using Rich Presence";
    homepage = "https://github.com/JakeStanger/mpd-discord-rpc/";
    changelog = "https://github.com/JakeStanger/mpd-discord-rpc/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mpd-discord-rpc";
  };
})
