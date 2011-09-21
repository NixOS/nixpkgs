{ fetchurl, stdenv, bash, emacs, gdb, git, glib, gmime, gnupg1, pkgconfig, talloc, xapian }:

stdenv.mkDerivation rec {
  name = "notmuch-0.8";

  src = fetchurl {
    url = "http://notmuchmail.org/releases/${name}.tar.gz";
    sha256 = "f40bcdc6447cae9f76d5b4e70ab70d87e4a813cd123b524c1dc3155a3371a949";
  };

  buildInputs = [ bash emacs gdb git glib gmime gnupg1 pkgconfig talloc xapian ];

  # XXX: Make me a loop
  patchPhase = ''
    # substituteInPlace "test/atomicity" \
    #   --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/aggregate-results.sh" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/author-order" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/basic" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/crypto" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/dump-restore" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/emacs" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/emacs-large-search-buffer" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/encoding" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/from-guessing" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/json" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/long-id" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/maildir-sync" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/new" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/notmuch-test" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/raw" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/reply" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/search" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/search-by-folder" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/search-insufficient-from-quoting" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/search-folder-coherence" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/search-output" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/search-position-overlap-bug" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/symbol-hiding" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/test-lib.sh" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/test-verbose" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/thread-naming" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/thread-order" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace "test/uuencode" \
      --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
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
