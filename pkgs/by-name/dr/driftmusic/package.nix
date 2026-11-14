{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  mpv,
  yt-dlp,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "driftmusic";
  version = "1.6.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "socatlolmeow";
    repo = "drift";
    tag = finalAttrs.version;
    hash = "sha256-u+/SVApKIcYKXn1m9LKk2PPuajMYiZPd07ZQcaWGyeg=";
  };

  cargoHash = "sha256-ssYxPofsQdM1PJtmxNPNdwymjNPk7qlEGokDnnKOU1k=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/drift \
      --prefix PATH : ${
        lib.makeBinPath [
          mpv
          yt-dlp
        ]
      }
  '';

  meta = {
    description = "Music streaming client for YouTube Music with Vim keybinds";
    homepage = "https://github.com/socatlolmeow/drift";
    license = lib.licenses.gpl3Plus;
    mainProgram = "drift";
    maintainers = with lib.maintainers; [ socat ];
    platforms = lib.platforms.linux;
  };
})
