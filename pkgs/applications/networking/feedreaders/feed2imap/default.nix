{ lib
, bundlerApp
, bundlerUpdateScript
}:

bundlerApp {
  pname = "feed2imap";
  gemdir = ./.;
  exes = [
    "feed2imap"
    "feed2imap-opmlimport"
    "feed2imap-cleaner"
    "feed2imap-dumpconfig"
  ];

  passthru.updateScript = bundlerUpdateScript "feed2imap";

  meta = with lib; {
    description = "feed aggregator (RSS/Atom) which puts items on a IMAP mail server";
    homepage = "https://github.com/feed2imap/feed2imap";
    license = licenses.gpl2;
    maintainers = with maintainers; [ nomeata ];
  };
}
