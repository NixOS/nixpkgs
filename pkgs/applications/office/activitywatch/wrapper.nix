{
  lib,
  symlinkJoin,
  aw-server-rust,
  aw-qt,
  aw-watcher-afk,
  aw-watcher-window,
  extraWatchers ? [ ],
}:

symlinkJoin {
  name = "activitywatch-${aw-server-rust.version}";
  paths = [
    aw-server-rust.out
    aw-qt.out
    aw-watcher-afk.out
    aw-watcher-window.out
  ] ++ (lib.forEach extraWatchers (p: p.out));
}
