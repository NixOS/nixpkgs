{ stdenv, fetchurl, zlib, htslib, perl, ncurses ? null }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "samtools";
  version = "1.7";

  src = fetchurl {
    url = "https://github.com/samtools/samtools/releases/download/${version}/${name}.tar.bz2";
    sha256 = "e7b09673176aa32937abd80f95f432809e722f141b5342186dfef6a53df64ca1";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ zlib ncurses htslib ];

  configureFlags = [ "--with-htslib=${htslib}" ]
    ++ stdenv.lib.optional (ncurses == null) "--without-curses";

  preCheck = ''
    patchShebangs test/
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Tools for manipulating SAM/BAM/CRAM format";
    license = licenses.mit;
    homepage = http://www.htslib.org/;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimadrid ];
  };
}
