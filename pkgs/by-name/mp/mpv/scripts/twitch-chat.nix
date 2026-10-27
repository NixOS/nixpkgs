{
  buildLua,
  curl,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildLua {
  pname = "twitch-chat";
  version = "0-unstable-2026-07-02";

  src = fetchFromGitHub {
    owner = "CrendKing";
    repo = "mpv-twitch-chat";
    rev = "72d97a02fae1045dedc44979e60403a198bbef1c";
    hash = "sha256-PaPCAmvARbRrL+NY+CcJGiQRO+Ahjo0o5vz1av3h2Ds=";

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
