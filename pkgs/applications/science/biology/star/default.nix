{ stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  name = "star-${version}";
  version = "2.6.1d";

  src = fetchFromGitHub {
    repo = "STAR";
    owner = "alexdobin";
    rev = version;
    sha256 = "1h0j8qj95a0brv7p3gxmg3z7z6f4670jzjg56kzyc33k8dmzxvli";
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
