{ fetchgit, stdenv, bash, emacs, glib, gmime, gnupg1, pkgconfig, talloc, xapian }:

stdenv.mkDerivation rec {
  name = "notmuch-0.5-cfl8";

  src = fetchgit {
    url = "git://github.com/chaoflow/notmuch";
    rev = "cfl8";
    sha256 = "ee39cd0b48511468f569220909ed46966f10f14ad118f2388843b823712b0333";
  };

  buildInputs = [ bash emacs glib gmime gnupg1 pkgconfig talloc xapian ];

  # XXX: Make me a loop
  patchPhase = ''
    substituteInPlace "test/author-order" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/basic" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/crypto" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/dump-restore" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/emacs" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/emacs-large-search-buffer" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/encoding" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/from-guessing" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/json" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/long-id" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/maildir-sync" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/new" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/notmuch-test" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/raw" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/reply" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/search" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/search-by-folder" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/search-insufficient-from-quoting" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/search-output" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/search-position-overlap-bug" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/test-lib.sh" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/test-verbose" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/thread-naming" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/thread-order" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace "test/uuencode" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
  '';

  postBuild = ''
    make test
  '';

  meta = {
    description = "Notmuch -- The mail indexer";

    longDescription = "";

    license = "GPLv3";

    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
