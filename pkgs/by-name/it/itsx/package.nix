{ lib, stdenv, fetchurl, hmmer, perl }:

stdenv.mkDerivation rec {
  version = "1.1.1";
  pname = "itsx";

  src = fetchurl {
    url = "http://microbiology.se/sw/ITSx_${version}.tar.gz";
    sha256 = "0lrmy2n3ax7f208k0k8l3yz0j5cpz05hv4hx1nnxzn0c51z1pc31";
  };

  buildInputs = [ hmmer perl ];

  buildPhase = ''
    sed -e "s,profileDB = .*,profileDB = \"$out/share/ITSx_db/HMMs\";," -i ITSx
    sed "3 a \$ENV{\'PATH\'}='${hmmer}/bin:'.\"\$ENV{\'PATH\'}\";" -i ITSx
    mkdir bin
    mv ITSx bin
  '';

  installPhase = ''
    mkdir -p $out/share/doc && cp -a bin $out/
    cp *pdf $out/share/doc
    cp -r ITSx_db $out/share
  '';

  meta = with lib; {
    description = "Improved software detection and extraction of ITS1 and ITS2 from ribosomal ITS sequences of fungi and other eukaryotes for use in environmental sequencing";
    mainProgram = "ITSx";
    homepage = "https://microbiology.se/software/itsx/";
    license = licenses.gpl3;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.unix;
  };
}
