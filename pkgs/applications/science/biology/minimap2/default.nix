{ stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "minimap2";
  version = "2.17";

  src = fetchFromGitHub {
    repo = pname;
    owner = "lh3";
    rev = "v${version}";
    sha256 = "0qdwlkib3aa6112372hdgvnvk86hsjjkhjar0p53pq4ajrr2cdlb";
  };

  buildInputs = [ zlib ];

  installPhase = ''
    mkdir -p $out/bin
    cp minimap2 $out/bin
    mkdir -p $out/share/man/man1
    cp minimap2.1 $out/share/man/man1
  '';
  
  meta = with stdenv.lib; {
    description = "A versatile pairwise aligner for genomic and spliced nucleotide sequences";
    homepage = https://lh3.github.io/minimap2;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.arcadio ];
  };
}
