{ fetchurl, stdenv, bash, emacs, gdb, git, glib, gmime, gnupg1, pkgconfig, talloc, xapian }:

stdenv.mkDerivation rec {
  name = "notmuch-0.8";

  src = fetchurl {
    url = "http://notmuchmail.org/releases/${name}.tar.gz";
    sha256 = "f40bcdc6447cae9f76d5b4e70ab70d87e4a813cd123b524c1dc3155a3371a949";
  };

  buildInputs = [ bash emacs gdb git glib gmime gnupg1 pkgconfig talloc xapian ];

  patchPhase = ''
    (cd test && for prg in \
        aggregate-results.sh \
        author-order \
        basic \
        crypto \
        dump-restore \
        emacs \
        emacs-large-search-buffer \
        encoding \
        from-guessing \
        json \
        long-id \
        maildir-sync \
        new \
        notmuch-test \
        raw \
        reply \
        search \
        search-by-folder \
        search-insufficient-from-quoting \
        search-folder-coherence \
        search-output \
        search-position-overlap-bug \
        symbol-hiding \
        test-lib.sh \
        test-verbose \
        thread-naming \
        thread-order \
        uuencode \
    ;do
      substituteInPlace "$prg" \
        --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    done)
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
