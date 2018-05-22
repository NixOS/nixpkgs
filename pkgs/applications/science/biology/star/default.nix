{ stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  name = "star-${version}";
  version = "2.6.0c";

  src = fetchFromGitHub {
    repo = "STAR";
    owner = "alexdobin";
    rev = version;
    sha256 = "04cj6jw8d9q6lk9c78wa4fky6jdlicf1d13plq7182h8vqiz8p59";
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
