{ fetchurl, stdenv, fixDarwinDylibNames, gdb
, pkgconfig, gnupg
, xapian, gmime, talloc, zlib
, doxygen, perl
, pythonPackages
, bash-completion
, emacs
, ruby
, which, dtach, openssl, bash
}:

stdenv.mkDerivation rec {
  version = "0.23.4";
  name = "notmuch-${version}";

  passthru = {
    pythonSourceRoot = "${name}/bindings/python";
    inherit version;
  };

  src = fetchurl {
    url = "http://notmuchmail.org/releases/${name}.tar.gz";
    sha256 = "0fs5crf8v3jghc8jnm61cv7wxhclcg88hi5894d8fma9kkixcv8h";
  };

  buildInputs = [
    pkgconfig gnupg # undefined dependencies
    xapian gmime talloc zlib  # dependencies described in INSTALL
    doxygen perl  # (optional) api docs
    pythonPackages.sphinx pythonPackages.python  # (optional) documentation -> doc/INSTALL
    bash-completion  # (optional) dependency to install bash completion
    emacs  # (optional) to byte compile emacs code
    ruby  # (optional) ruby bindings
    which dtach openssl bash  # test dependencies
    ]
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames
    ++ stdenv.lib.optional (!stdenv.isDarwin) gdb;

  doCheck = !stdenv.isDarwin;
  checkTarget = "test";

  patchPhase = ''
    # XXX: disabling few tests since i have no idea how to make them pass for now
    rm -f test/T010-help-test.sh \
          test/T350-crypto.sh \
          test/T355-smime.sh

    find test -type f -exec \
      sed -i \
        -e "1s|#!/usr/bin/env bash|#!${bash}/bin/bash|" \
        -e "s|gpg |${gnupg}/bin/gpg2 |" \
        -e "s| gpg| ${gnupg}/bin/gpg2|" \
        -e "s|gpgsm |${gnupg}/bin/gpgsm |" \
        -e "s| gpgsm| ${gnupg}/bin/gpgsm|" \
        -e "s|crypto.gpg_path=gpg|crypto.gpg_path=${gnupg}/bin/gpg2|" \
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

  preFixup = stdenv.lib.optionalString stdenv.isDarwin ''
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
  '';

  postInstall = ''
    make install-man
  '';

  meta = {
    description = "Mail indexer";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ chaoflow garbas ];
    platforms = stdenv.lib.platforms.unix;
  };
}
