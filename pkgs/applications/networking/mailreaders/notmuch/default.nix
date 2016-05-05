{ fetchurl, stdenv, bash, emacs, fixDarwinDylibNames
, gdb, glib, gmime, gnupg
, pkgconfig, talloc, xapian
, sphinx, python
}:

stdenv.mkDerivation rec {
  name = "notmuch-0.22";

  passthru = {
    pythonSourceRoot = "${name}/bindings/python";
  };

  src = fetchurl {
    url = "http://notmuchmail.org/releases/${name}.tar.gz";
    sha256 = "16mrrw6xpsgip4dy8rfx0zncij5h41fsg2aah6x6z83bjbpihhfn";
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
      notmuch-config.c \
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
      set -e

      die() {
        >&2 echo "$@"
        exit 1
      }

      prg="$out/bin/notmuch"
      lib="$(find "$out/lib" -name 'libnotmuch.?.dylib')"

      [[ -s "$prg" ]] || die "couldn't find notmuch binary"
      [[ -s "$lib" ]] || die "couldn't find libnotmuch"

      badname="$(otool -L "$prg" | awk '$1 ~ /libtalloc/ { print $1 }')"
      goodname="$(find "${talloc}/lib" -name 'libtalloc.?.?.?.dylib')"

      [[ -n "$badname" ]]  || die "couldn't find libtalloc reference in binary"
      [[ -n "$goodname" ]] || die "couldn't find libtalloc in nix store"

      echo "fixing libtalloc link in $lib"
      install_name_tool -change "$badname" "$goodname" "$lib"

      echo "fixing libtalloc link in $prg"
      install_name_tool -change "$badname" "$goodname" "$prg"
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
    platforms = stdenv.lib.platforms.unix;
  };
}
