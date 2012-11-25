{ fetchurl, stdenv, bash, emacs, gdb, glib, gmime, gnupg1,
  pkgconfig, talloc, xapian
}:

stdenv.mkDerivation rec {
  name = "notmuch-0.14";

  src = fetchurl {
    url = "http://notmuchmail.org/releases/${name}.tar.gz";
    sha256 = "095e191dc0f3125c4fd98440fdf55050cba01b8e9f68245ffe0190a7f39ca753";
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
