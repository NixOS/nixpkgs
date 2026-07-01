{
  buildLua,
  curl,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildLua {
  pname = "twitch-chat";
  version = "0-unstable-2026-06-13";

  src = fetchFromGitHub {
    owner = "CrendKing";
    repo = "mpv-twitch-chat";
    rev = "1e9d2dfcd8ab9c343cc6a3c55363994dbafe5b58";
    hash = "sha256-vtv5YZO7qROhUL3TKCKaNfvv1uCjQv9kvfo7sno24BE=";

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
    maintainers = [ lib.maintainers.noahbiewesch ];
  };
}
