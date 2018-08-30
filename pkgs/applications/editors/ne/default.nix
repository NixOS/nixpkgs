{ stdenv, fetchFromGitHub, ncurses, texinfo, texlive, perl, ghostscript }:


stdenv.mkDerivation rec {
  name = "ne-${version}";
  version = "3.1.1";
  src = fetchFromGitHub {
    owner = "vigna";
    repo = "ne";
    rev = version;
    sha256 = "1i4vk5r2wn4cd6sgsidzqs9s3bmb4j9cn4392izkidi0j9mm3hvg";
  };
  buildInputs = [ ncurses texlive.combined.scheme-medium texinfo perl ghostscript ];
  dontBuild = true;
  installPhase = ''
    substituteInPlace src/makefile --replace "CC=c99" "cc=gcc"
    substituteInPlace src/makefile --replace "-lcurses" "-lncurses"
    substituteInPlace makefile --replace "./version.pl" "perl version.pl"
    cd doc && make && cd ..
    cd src && make && cd ..
    make PREFIX=$out install
  '';

  meta = {
    description = "The nice editor";
    homepage = https://github.com/vigna/ne;
    longDescription = ''
      ne is a free (GPL'd) text editor based on the POSIX standard that runs
      (we hope) on almost any UN*X machine.  ne is easy to use for the beginner,
      but powerful and fully configurable for the wizard, and most sparing in its
      resource usage.  See the manual for some highlights of ne's features.
    '';
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
  };
}
