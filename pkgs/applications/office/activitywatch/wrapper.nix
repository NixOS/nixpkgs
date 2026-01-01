{
  lib,
  symlinkJoin,
  aw-server-rust,
  aw-qt,
  aw-notify,
  aw-watcher-afk,
  aw-watcher-window,
  extraWatchers ? [ ],
}:

symlinkJoin {
  name = "activitywatch-${aw-server-rust.version}";
  paths = [
    aw-server-rust.out
    aw-qt.out
    aw-notify.out
    aw-watcher-afk.out
    aw-watcher-window.out
  ]
  ++ (lib.forEach extraWatchers (p: p.out));

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Best free and open-source automated time tracker";
    homepage = "https://activitywatch.net/";
    downloadPage = "https://github.com/ActivityWatch/activitywatch/releases";
    changelog = "https://github.com/ActivityWatch/activitywatch/releases/tag/v${aw-server-rust.version}";
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ huantian ];
    mainProgram = "aw-qt";
    platforms = lib.platforms.linux;
    license = lib.licenses.mpl20;
=======
    maintainers = with maintainers; [ huantian ];
    mainProgram = "aw-qt";
    platforms = platforms.linux;
    license = licenses.mpl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
