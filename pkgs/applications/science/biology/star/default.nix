{ stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  name = "star-${version}";
  version = "2.7.0c";

  src = fetchFromGitHub {
    repo = "STAR";
    owner = "alexdobin";
    rev = version;
    sha256 = "0r5jcckr45f71jwhz8xazi1w6kfhszq3y6r7f6zl9963ms1q1gfv";
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
