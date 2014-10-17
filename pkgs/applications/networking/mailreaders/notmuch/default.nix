{ fetchurl, stdenv, bash, emacs, gdb, glib, gmime, gnupg,
  pkgconfig, talloc, xapian
}:

stdenv.mkDerivation rec {
  name = "notmuch-0.18.1";

  src = fetchurl {
    url = "http://notmuchmail.org/releases/${name}.tar.gz";
    sha256 = "1pdp9l7yv71d3fjb30qyccva8h03hvg88q4a00yi50v2j70kvmgj";
  };

  buildInputs = [ bash emacs gdb glib gmime gnupg pkgconfig talloc xapian ];

  patchPhase = ''
    find test -type f -exec \
      sed -i \
        "1s_#!/usr/bin/env bash_#!${bash}/bin/bash_" \
        "{}" ";"

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
    description = "Mail indexer";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ chaoflow garbas ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
