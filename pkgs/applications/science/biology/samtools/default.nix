{ stdenv, fetchurl, zlib, htslib,  ncurses ? null }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "samtools";
  major = "1.4";
  version = "${major}.0";

  src = fetchurl {
    url = "https://github.com/samtools/samtools/releases/download/${major}/samtools-${major}.tar.bz2";
    sha256 = "1x73c0lxvd58ghrmaqqyp56z7bkmp28a71fk4ap82j976pw5pbls";
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
