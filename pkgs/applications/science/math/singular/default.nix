{ stdenv, fetchurl, gmp, bison, perl, autoconf, ncurses, readline, coreutils, pkgconfig
, asLibsingular ? false
, autoreconfHook
}:

stdenv.mkDerivation rec {
  name = "singular-${version}";
  version="4-1-0";

  src = fetchurl {
    url = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/${version}/singular-4.1.0p3.tar.gz";
    sha256 = "105zs3zk46b1cps403ap9423rl48824ap5gyrdgmg8fma34680a4";
  };

  buildInputs = [ autoreconfHook gmp perl ncurses readline ];
  nativeBuildInputs = [ bison pkgconfig ];

  postPatch=''
    patchShebangs libpolys/tests/cxxtestgen.pl
    patchShebangs git-version-gen
  '';

  preConfigure = ''
    find . -type f -exec sed -e 's@/bin/rm@${coreutils}&@g' -i '{}' ';'
    find . -type f -exec sed -e 's@/bin/uname@${coreutils}&@g' -i '{}' ';'
  '';

  hardeningDisable = stdenv.lib.optional stdenv.isi686 "stackprotector";

  # The Makefile actually defaults to `make install` anyway
  buildPhase = "true;";

  installPhase = ''
    mkdir -p "$out"
    cp -r Singular/LIB "$out/LIB"
    make install

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
    homepage = http://www.singular.uni-kl.de/index.php;
    downloadPage = http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/;
  };
}
