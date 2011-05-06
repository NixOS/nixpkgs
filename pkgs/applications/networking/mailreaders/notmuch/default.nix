{ fetchgit, stdenv, bash, emacs, gdb, git, glib, gmime, gnupg1, pkgconfig, talloc, xapian }:

stdenv.mkDerivation rec {
  name = "notmuch-0.6-rc1";

  src = fetchgit {
    url = "git://github.com/chaoflow/notmuch";
    rev = "236dc05f919a2deda8ed7f65bb8f52e0c39cd017";
    sha256 = "7045f0cfee3d44f404e2a40295cfc586f803f9d6cabb063f0256e468a8be3670";
  };

  buildInputs = [ bash emacs gdb git glib gmime gnupg1 pkgconfig talloc xapian ];

  # XXX: Make me a loop
  patchPhase = ''
    substituteInPlace "test/atomicity" \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
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
