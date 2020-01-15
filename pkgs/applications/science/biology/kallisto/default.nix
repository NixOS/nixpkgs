{ stdenv, fetchFromGitHub, autoconf, cmake, hdf5, zlib }:

stdenv.mkDerivation rec {
  pname = "kallisto";
  version = "0.46.0";

  src = fetchFromGitHub {
    repo = "kallisto";
    owner = "pachterlab";
    rev = "v${version}";
    sha256 = "09vgdqwpigl4x3sdw5vjfyknsllkli339mh8xapbf7ldm0jldfn9";
  };

  nativeBuildInputs = [ autoconf cmake ];

  buildInputs = [ hdf5 zlib ];

  # Parallel build fails in some cases: https://github.com/pachterlab/kallisto/issues/160
  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    description = "Kallisto is a program for quantifying abundances of transcripts from RNA-Seq data";
    homepage = "https://pachterlab.github.io/kallisto";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arcadio ];
  };
}
