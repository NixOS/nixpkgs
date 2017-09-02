{ stdenv, fetchurl, zlib, htslib,  ncurses ? null }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "samtools";
  major = "1.5";
  version = "${major}.0";

  src = fetchurl {
    url = "https://github.com/samtools/samtools/releases/download/${major}/samtools-${major}.tar.bz2";
    sha256 = "1xidmv0jmfy7l0kb32hdnlshcxgzi1hmygvig0cqrq1fhckdlhl5";
  };

  buildInputs = [ zlib ncurses ];

  configureFlags = [ "--with-htslib=${htslib}" ]
    ++ stdenv.lib.optional (ncurses == null) "--without-curses";

  meta = with stdenv.lib; {
    description = "Tools for manipulating SAM/BAM/CRAM format";
    license = licenses.mit;
    homepage = http://www.htslib.org/;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimadrid ];
  };
}
