{ stdenv, fetchurl, gmp, bison, perl, autoconf, ncurses, readline, coreutils }:

stdenv.mkDerivation rec {
  name = "singular-${version}";
  version="3-1-7";

  src = fetchurl {
    url = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/${version}/Singular-${version}.tar.gz";
    sha256 = "1j4mcpnwzdp3h4qspk6ww0m67rmx4s11cy17pvzbpf70lm0jzzh2";
  };

  buildInputs = [ gmp bison perl autoconf ncurses readline coreutils ];

  preConfigure = ''
    find . -exec sed -e 's@/bin/rm@${coreutils}&@g' -i '{}' ';'
    find . -exec sed -e 's@/bin/uname@${coreutils}&@g' -i '{}' ';'
  '';

  hardeningDisable = stdenv.lib.optional stdenv.isi686 "stackprotector";

  postInstall = ''
    rm -rf "$out/LIB"
    cp -Tr Singular/LIB "$out/lib"
    ln -s "$out"/*/include "$out"
    mkdir -p "$out/bin"
    ln -s "$out/"*/Singular "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "A CAS for polynomial computations";
    maintainers = with maintainers;
      [ raskin ];
    platforms = platforms.linux;
    license = licenses.gpl3; # Or GPLv2 at your option - but not GPLv4
    homepage = "http://www.singular.uni-kl.de/index.php";
    downloadPage = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/";
  };
}
