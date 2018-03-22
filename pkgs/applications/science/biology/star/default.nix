{ stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  name = "star-${version}";
  version = "2.5.3a";

  src = fetchFromGitHub {
    repo = "STAR";
    owner = "alexdobin";
    rev = version;
    sha256 = "1fd9xl7i1zxgsxn2qf6gz8s42g2djm29qmp6qb35d8nnxh8ns54x";
  };

  sourceRoot = "source/source";
  
  postPatch = "sed 's:/bin/rm:rm:g' -i Makefile";
  
  buildInputs = [ zlib ];
  
  buildPhase = "make STAR STARlong";

  installPhase = ''
    mkdir -p $out/bin
    cp STAR STARlong $out/bin
  '';
  
  meta = with stdenv.lib; {
    description = "Spliced Transcripts Alignment to a Reference";
    homepage = https://github.com/alexdobin/STAR;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.arcadio ];
  };
}
