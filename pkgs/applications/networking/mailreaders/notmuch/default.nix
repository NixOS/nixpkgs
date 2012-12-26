{ fetchurl, stdenv, bash, emacs, gdb, glib, gmime, gnupg1,
  pkgconfig, talloc, xapian
}:

stdenv.mkDerivation rec {
  name = "notmuch-0.13.2";

  src = fetchurl {
    url = "http://notmuchmail.org/releases/${name}.tar.gz";
    sha256 = "75ec5f5d04bb7e3a8cc6224859b691f704a2a35f2f6027ffb674e829268f1d68";
  };

  buildInputs = [ bash emacs gdb glib gmime gnupg1 pkgconfig talloc xapian ];

  patchPhase = ''
    (cd test && for prg in \
        aggregate-results.sh \
        argument-parsing \
        atomicity \
        author-order \
        basic \
        crypto \
        count \
        dump-restore \
        emacs \
        emacs-large-search-buffer \
        encoding \
        from-guessing \
        help-test \
        hooks \
        json \
        long-id \
        maildir-sync \
        multipart \
        new \
        notmuch-test \
        python \
        raw \
        reply \
        search \
        search-by-folder \
        search-insufficient-from-quoting \
        search-folder-coherence \
        search-limiting \
        search-output \
        search-position-overlap-bug \
        symbol-hiding \
        tagging \
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

  # XXX: emacs tests broken
  doCheck = false;
  checkTarget = "test";

  meta = {
    description = "Notmuch -- The mail indexer";
    longDescription = "";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ chaoflow ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
