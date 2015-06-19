{ stdenv, fetchurl, unzip, writeText, bash, pdf2xml, xpdf, libxml2,  makeWrapper, grobid-native-libs }:
let
  grobidProperties = writeText "grobid.properties" (import ./grobid.properties.nix {
    grobidTempPath = "/tmp/grobid";
    grobidNativeLibsPath = "${grobid-native-libs}";
    pdf2xmlMemoryLimitMb = 2048;
  });
in
stdenv.mkDerivation rec {
  name = "grobid-home-${version}";
  version = "2015-04-29";
  src = fetchurl {
    url = "https://github.com/allenai/grobid/zipball/${version}";
    sha256 = "06n44zjw9bdjpg37v6907hfixdl5j6lkdvff0l4fc4a1k63my4zf";
    name = "grobid-src-${version}.zip";
  };

  buildInputs = [unzip bash makeWrapper pdf2xml];
  
  installPhase = ''
    mkdir -p $out
    rm -rf ./grobid-home/lib
    mv ./grobid-home/* $out
    
    cp ${grobidProperties} $out/config/grobid.properties

    rm -rf $out/pdf2xml/*
    mkdir $out/pdf2xml/lin-64
    cp -R ${pdf2xml}/bin/* $out/pdf2xml/lin-64
   '';
  
  meta = with stdenv.lib; {
    homepage = "https://github.com/allenai/grobid";
    description = "the allenai grobid home";
  };
}
