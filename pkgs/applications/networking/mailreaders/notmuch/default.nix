{ fetchurl, stdenv, bash, emacs, gdb, git, glib, gmime, gnupg1, pkgconfig, talloc, xapian }:

stdenv.mkDerivation rec {
  name = "notmuch-0.9";

  src = fetchurl {
    url = "http://notmuchmail.org/releases/${name}.tar.gz";
    sha256 = "e6f1046941d2894d143cb7c19d4810f97946f98742f6d9b8a7208ddb858c57e4";
  };

  buildInputs = [ bash emacs gdb git glib gmime gnupg1 pkgconfig talloc xapian ];

  patchPhase = ''
    (cd test && for prg in \
        aggregate-results.sh \
        atomicity \
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
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
