{ lib, stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  pname = "samtools";
  version = "0.1.19";

  src = fetchurl {
    url = "mirror://sourceforge/samtools/${pname}-${version}.tar.bz2";
    sha256 = "d080c9d356e5f0ad334007e4461cbcee3c4ca97b8a7a5a48c44883cf9dee63d4";
  };

  patches = [
    ./samtools-0.1.19-no-curses.patch
  ];

  buildInputs = [ zlib ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man

    cp samtools $out/bin
    cp samtools.1 $out/share/man
  '';

  meta = with lib; {
    description = "Tools for manipulating SAM/BAM/CRAM format";
    license = licenses.mit;
    homepage = "https://samtools.sourceforge.net/";
    platforms = platforms.unix;
    maintainers = [ maintainers.unode ];
  };
}
