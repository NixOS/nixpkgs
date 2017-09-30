{ stdenv, fetchurl, zlib, htslib, perl, ncurses ? null }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "samtools";
  major = "1.6";
  version = "${major}.0";

  src = fetchurl {
    url = "https://github.com/samtools/samtools/releases/download/${major}/samtools-${major}.tar.bz2";
    sha256 = "17p4vdj2j2qr3b2c0v4100h6cg4jj3zrb4dmdnd9d9aqs74d4p7f";
  };

  buildInputs = [ zlib ncurses ];

  propagatedBuildInputs = [ htslib ];

  configureFlags = [ "--with-htslib=${htslib}" ]
    ++ stdenv.lib.optional (ncurses == null) "--without-curses";

  enableParallelBuilding = true;

  doCheck = true;

  preCheck = ''
    sed -ie 's|/usr/bin/\(env[[:space:]]\)\{0,1\}perl|${perl}/bin/perl|' test/test.pl
  '';

  meta = with stdenv.lib; {
    description = "Tools for manipulating SAM/BAM/CRAM format";
    license = licenses.mit;
    homepage = http://www.htslib.org/;
    platforms = platforms.unix;
    maintainers = [ maintainers.mimadrid ];
  };
}
