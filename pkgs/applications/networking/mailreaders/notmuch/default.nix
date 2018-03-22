{ fetchurl, stdenv, fixDarwinDylibNames
, pkgconfig, gnupg
, xapian, gmime, talloc, zlib
, doxygen, perl
, pythonPackages
, bash-completion
, emacs
, ruby
, which, dtach, openssl, bash, gdb, man
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "0.26";
  name = "notmuch-${version}";

  passthru = {
    pythonSourceRoot = "${name}/bindings/python";
    inherit version;
  };

  src = fetchurl {
    url = "http://notmuchmail.org/releases/${name}.tar.gz";
    sha256 = "1pvn1n7giv8n3xlazi3wpscdqhd2yak0fgv68aj23myr5bnr9s6k";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gnupg # undefined dependencies
    xapian gmime talloc zlib  # dependencies described in INSTALL
    doxygen perl  # (optional) api docs
    pythonPackages.sphinx pythonPackages.python  # (optional) documentation -> doc/INSTALL
    bash-completion  # (optional) dependency to install bash completion
    emacs  # (optional) to byte compile emacs code
    ruby  # (optional) ruby bindings
    which dtach openssl bash  # test dependencies
  ]
  ++ optional stdenv.isDarwin fixDarwinDylibNames
  ++ optionals (!stdenv.isDarwin) [ gdb man ]; # test dependencies

  postPatch = ''
    find test/ -type f -exec \
      sed -i \
        -e "1s|#!/usr/bin/env bash|#!${bash}/bin/bash|" \
        "{}" ";"

    for src in \
      util/crypto.c \
      notmuch-config.c
    do
      substituteInPlace "$src" \
        --replace \"gpg\" \"${gnupg}/bin/gpg\"
    done
  '';

  # Notmuch doesn't use autoconf and consequently doesn't tag --bindir and
  # friends
  setOutputFlags = false;
  enableParallelBuilding = true;
  makeFlags = "V=1";

  preFixup = optionalString stdenv.isDarwin ''
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
    goodname="$(find "${talloc}/lib" -name 'libtalloc.*.*.*.dylib')"

    [[ -n "$badname" ]]  || die "couldn't find libtalloc reference in binary"
    [[ -n "$goodname" ]] || die "couldn't find libtalloc in nix store"

    echo "fixing libtalloc link in $lib"
    install_name_tool -change "$badname" "$goodname" "$lib"

    echo "fixing libtalloc link in $prg"
    install_name_tool -change "$badname" "$goodname" "$prg"
  '';

  doCheck = !stdenv.isDarwin && (versionAtLeast gmime.version "3.0");
  checkTarget = "test V=1";

  postInstall = ''
    make install-man
  '';

  dontGzipMan = true; # already compressed

  meta = {
    description = "Mail indexer";
    homepage    = https://notmuchmail.org/;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ chaoflow flokli garbas the-kenny ];
    platforms   = platforms.unix;
  };
}
