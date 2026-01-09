{
  buildLua,
  curl,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildLua {
  pname = "twitch-chat";
  version = "0-unstable-2025-05-15";

  src = fetchFromGitHub {
    owner = "CrendKing";
    repo = "mpv-twitch-chat";
    rev = "4d88ac12c843da0e916b0ed1df4d087a3418501b";
    hash = "sha256-owU0F976K4CX0kKYoRbdtz/sqCvd8kw2LqItEgY25gE=";

    postFetch = "rm $out/screenshot.webp";
  };

  scriptPath = ".";

  runtime-dependencies = [ curl ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Show Twitch chat messages as subtitles when watching Twitch VOD with mpv";
    homepage = "https://github.com/CrendKing/mpv-twitch-chat";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.naho ];
  };
}
