{ stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  name = "star-${version}";
  version = "2.6.1c";

  src = fetchFromGitHub {
    repo = "STAR";
    owner = "alexdobin";
    rev = version;
    sha256 = "0macdbxa0v5xplag83fpdhfpyhnqncmi9wf9r92wa7w8zkln12vd";
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
