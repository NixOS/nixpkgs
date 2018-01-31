{ stdenv, fetchFromGitHub, cmake, hdf5, zlib }:

stdenv.mkDerivation rec {
  name = "kallisto-${version}";
  version = "0.43.1";

  src = fetchFromGitHub {
    repo = "kallisto";
    owner = "pachterlab";
    rev = "v${version}";
    sha256 = "04697pf7jvy7vw126s1rn09q4iab9223jvb1nb0jn7ilwkq7pgwz";
  };

  nativeBuildInputs = [ cmake ];
  
  buildInputs = [ hdf5 zlib ];

  meta = with stdenv.lib; {
    description = "kallisto is a program for quantifying abundances of transcripts from RNA-Seq data";
    homepage = https://pachterlab.github.io/kallisto;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.arcadio ];
  };
}
