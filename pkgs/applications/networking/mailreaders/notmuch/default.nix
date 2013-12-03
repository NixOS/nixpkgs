{ fetchurl, stdenv, bash, emacs, gdb, glib, gmime, gnupg,
  pkgconfig, talloc, xapian
}:

stdenv.mkDerivation rec {
  name = "notmuch-0.16";

  src = fetchurl {
    url = "http://notmuchmail.org/releases/${name}.tar.gz";
    sha256 = "0i7k85lfp9l0grmq7cvai2f3pw15jcrhcp96mmamr15y2pn2syg7";
  };

  buildInputs = [ bash emacs gdb glib gmime gnupg pkgconfig talloc xapian ];

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

    for src in \
      crypto.c \
      emacs/notmuch-crypto.el
    do
      substituteInPlace "$src" \
        --replace \"gpg\" \"${gnupg}/bin/gpg2\"
    done
  '';

  # XXX: emacs tests broken
  doCheck = false;
  checkTarget = "test";

  meta = {
    description = "Notmuch -- The mail indexer";
    longDescription = "";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ chaoflow garbas ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
