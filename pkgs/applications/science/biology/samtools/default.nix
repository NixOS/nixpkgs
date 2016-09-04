{ stdenv, fetchurl, zlib, htslib,  ncurses ? null }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "samtools";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/samtools/${pname}/releases/download/${version}/${name}.tar.bz2";
    sha256 = "0znnnxc467jbf1as2dpskrjhfh8mbll760j6w6rdkwlwbqsp8gbc";
  };

  buildInputs = [ zlib ncurses htslib ];

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
