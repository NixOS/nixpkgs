{
  lib,
  buildLua,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildLua {
  pname = "playlist-dir-conf";
  version = "0-unstable-2026-04-02";

  src = fetchFromGitHub {
    owner = "zzzealed";
    repo = "mpv-playlist-dir-conf";
    rev = "aac34c612a1ded93abf9234cf78be05acbce9b95";
    hash = "sha256-lbaJ3WsEPxigrUFzS/ip6d6cfGT5bMDOFdYF+yIxIWE=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "MPV script that loads a config from a playlists directory";
    longDescription = "MPV script that loads a mpv.conf from the directory of the playlist, extending `--use-filedir-conf` behavior to work with playlists";
    homepage = "https://github.com/zzzealed/mpv-playlist-dir-conf";
    maintainers = with lib.maintainers; [ zeal ];
  };
}
