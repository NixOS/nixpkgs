{ lib
, fetchFromGitHub
, unstableGitUpdater
, buildLua }:

buildLua rec {
  pname = "mpv-reload";

  version = "unstable-2023-12-19";
  src = fetchFromGitHub {
    owner = "4e6";
    repo  = pname;
    rev   = "133d596f6d369f320b4595bbed1f4a157b7b9ee5";
    hash  = "sha256-B+4TCmf1T7MuwtbL+hGZoN1ktI31hnO5yayMG1zW8Ng=";
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
