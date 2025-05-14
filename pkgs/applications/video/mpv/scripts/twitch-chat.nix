{
  buildLua,
  curl,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildLua {
  pname = "twitch-chat";
  version = "0-unstable-2025-03-30";

  src = fetchFromGitHub {
    owner = "CrendKing";
    repo = "mpv-twitch-chat";
    rev = "97c94ae58b4a898067b9c63c477716280327d8e1";
    hash = "sha256-KjlzVuj47zos2RQHbveijsyJoN2f7VGBboWolISom7M=";

    postFetch = "rm $out/screenshot.webp";
  };

  scriptPath = ".";

  runtime-dependencies = [ curl ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Show Twitch chat messages as subtitles when watching Twitch VOD with mpv.";
    homepage = "https://github.com/CrendKing/mpv-twitch-chat";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.naho ];
  };
}
