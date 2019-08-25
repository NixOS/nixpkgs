{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "sup";
  gemdir = ./.;
  exes = [
    "sup"
    "sup-add"
    "sup-config"
    "sup-dump"
    "sup-import-dump"
    "sup-psych-ify-config-files"
    "sup-recover-sources"
    "sup-sync"
    "sup-sync-back-maildir"
    "sup-tweak-labels"
  ];

  passthru.updateScript = bundlerUpdateScript "sup";

  meta = with lib; {
    description = "A curses threads-with-tags style email client";
    homepage    = http://sup-heliotrope.github.io;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ cstrahan lovek323 manveru nicknovitski ];
    platforms   = platforms.unix;
  };
}
