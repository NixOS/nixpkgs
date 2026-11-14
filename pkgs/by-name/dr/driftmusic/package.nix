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
  version = "1.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "socatlolmeow";
    repo = "drift";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GAKe6EFF5s3i5wkiCLddqxvliKN9IzHghlmpBnUGi5I=";
  };

  cargoHash = "sha256-otMU12RyrNCFNcyYox5EVjFLsXiZpbwIX8NXQWI6DIU=";

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
