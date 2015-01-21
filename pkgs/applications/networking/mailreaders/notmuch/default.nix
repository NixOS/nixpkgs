{ fetchurl, stdenv, bash, emacs, fixDarwinDylibNames
, gdb, glib, gmime, gnupg
, pkgconfig, talloc, xapian
, sphinx, python
}:

stdenv.mkDerivation rec {
  name = "notmuch-0.19";

  src = fetchurl {
    url = "http://notmuchmail.org/releases/${name}.tar.gz";
    sha256 = "1szf6c44g209pcjq5nvfhlp3nzcm3lrcwv4spsxmwy13hiaccvrr";
  };

  buildInputs = [ bash emacs glib gmime gnupg pkgconfig talloc xapian sphinx python ]
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames
    ++ stdenv.lib.optional (!stdenv.isDarwin) gdb;

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

  postInstall = ''
    make install-man
  '';

  preFixup = if stdenv.isDarwin then
    ''
      prg="$out/bin/notmuch"
      target="libnotmuch.3.dylib"
      echo "$prg: fixing link to $target"
      install_name_tool -change "$target" "$out/lib/$target" "$prg"
    ''
  else
    "";

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
