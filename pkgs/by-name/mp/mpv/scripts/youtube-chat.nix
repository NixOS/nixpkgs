{
  lib,
  buildLua,
  fetchFromGitHub,
  yt-dlp,
}:

buildLua {
  pname = "youtube-chat";
  version = "unstable-2024-06-08";

  src = fetchFromGitHub {
    owner = "BanchouBoo";
    repo = "mpv-youtube-chat";
    rev = "4b8d6d5d3ace40d467bc0ed75f3af2a1aefce161";
    hash = "sha256-uZC7iDYqLUuXnqSLke4j6rLoufc/vFTE6Ehnpu//dxY=";
  };

  scriptPath = "youtube-chat";

  installPhase = ''
    runHook preInstall
    install -D -t $out/share/mpv/scripts/youtube-chat main.lua
    runHook postInstall
  '';

  passthru.extraWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ yt-dlp ])
  ];

  meta = {
    description = "MPV script to overlay youtube chat on top of a video using yt-dlp";
    homepage = "https://github.com/BanchouBoo/mpv-youtube-chat";
    license = lib.licenses.mit;
    platforms = yt-dlp.meta.platforms;
    maintainers = with lib.maintainers; [ fliegendewurst ];
  };
}
