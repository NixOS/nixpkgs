{ lib
, fetchFromGitHub
, unstableGitUpdater
, buildLua }:

buildLua rec {
  pname = "mpv-reload";

  version = "unstable-2024-03-22";
  src = fetchFromGitHub {
    owner = "4e6";
    repo  = pname;
    rev   = "1a6a9383ba1774708fddbd976e7a9b72c3eec938";
    hash  = "sha256-BshxCjec/UNGyiC0/g1Rai2NvG2qOIHXDDEUYwwdij0=";
  };
  passthru.updateScript = unstableGitUpdater {};

  meta = {
    description = "Manual & automatic reloading of videos";
    longDescription = ''
      This script adds reloading of videos, automatically on timers (when stuck
      buffering etc.) or manually on keybinds, to help with cases where a stream
      is not loading further due to a network or remote issue.
    '';
    homepage = "https://github.com/4e6/mpv-reload";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nicoo ];
  };
}
