{ lib, bundlerApp, rake, which }:

# Updated with:
# rm gemset.nix Gemfile.lock
# nix-shell -p bundler bundix --run 'bundle lock && bundix'

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

  meta = with lib; {
    description = "A curses threads-with-tags style email client";
    homepage    = http://sup-heliotrope.github.io;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ cstrahan lovek323 manveru ];
    platforms   = platforms.unix;
  };
}
