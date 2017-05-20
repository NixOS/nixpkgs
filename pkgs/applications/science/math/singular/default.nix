{ stdenv, fetchurl, gmp, bison, perl, autoconf, ncurses, readline, coreutils, pkgconfig
, asLibsingular ? false
}:

stdenv.mkDerivation rec {
  name = "singular-${version}";
  version="3-1-7";

  src = fetchurl {
    url = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/${version}/Singular-${version}.tar.gz";
    sha256 = "1j4mcpnwzdp3h4qspk6ww0m67rmx4s11cy17pvzbpf70lm0jzzh2";
  };

  buildInputs = [ gmp perl ncurses readline ];
  nativeBuildInputs = [ autoconf bison pkgconfig ];

  preConfigure = ''
    find . -exec sed -e 's@/bin/rm@${coreutils}&@g' -i '{}' ';'
    find . -exec sed -e 's@/bin/uname@${coreutils}&@g' -i '{}' ';'
    ${stdenv.lib.optionalString asLibsingular ''NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DLIBSINGULAR"''}
  '';

  hardeningDisable = stdenv.lib.optional stdenv.isi686 "stackprotector";

  # The Makefile actually defaults to `make install` anyway
  buildPhase = "true;";

  installPhase = ''
    mkdir -p "$out"
    cp -r Singular/LIB "$out/LIB"
    make install${stdenv.lib.optionalString asLibsingular "-libsingular"}

    binaries="$(find "$out"/* \( -type f -o -type l \) -perm -111 \! -name '*.so' -maxdepth 1)"
    ln -s "$out"/*/{include,lib} "$out"
    mkdir -p "$out/bin"
    for b in $binaries; do
      bbn="$(basename "$b")"
      echo -e '#! ${stdenv.shell}\n"'"$b"'" "$@"' > "$out/bin/$bbn"
      chmod a+x "$out/bin/$bbn"
    done
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A CAS for polynomial computations";
    maintainers = with maintainers; [ raskin ];
    platforms = subtractLists platforms.i686 platforms.linux;
    license = licenses.gpl3; # Or GPLv2 at your option - but not GPLv4
    homepage = "http://www.singular.uni-kl.de/index.php";
    downloadPage = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/";
  };
}
