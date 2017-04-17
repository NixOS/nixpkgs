{ stdenv, fetchurl, unzip, writeText, bash, pdf2xml, xpdf, libxml2,  makeWrapper }:

stdenv.mkDerivation rec {
  name = "grobid-native-libs-${version}";
  version = "2015-04-29";
  src = fetchurl {
    url = "https://github.com/allenai/grobid/zipball/${version}";
    sha256 = "06n44zjw9bdjpg37v6907hfixdl5j6lkdvff0l4fc4a1k63my4zf";
    name = "grobid-src-${version}.zip";
  };

  buildInputs = [unzip bash makeWrapper pdf2xml];
  
  installPhase = ''
    mkdir -p $out
    mv ./grobid-home/lib/* $out
   '';
  
  meta = with stdenv.lib; {
    homepage = "https://github.com/allenai/grobid";
    description = "the allenai grobid native libs";
  };
}
