{ lib, stdenv, fetchurl, gcc, zlib, python27 }:

stdenv.mkDerivation rec {
  pname = "ecopcr";
  version = "0.8.0";

  src = fetchurl {
    url = "https://git.metabarcoding.org/obitools/ecopcr/uploads/6f37991b325c8c171df7e79e6ae8d080/ecopcr-${version}.tar.gz";
    sha256 = "10c58hj25z78jh0g3zcbx4890yd2qrvaaanyx8mn9p49mmyf5pk6";
  };

  sourceRoot = "ecoPCR/src";

  buildInputs = [ gcc python27 zlib ];

  installPhase = ''
    mkdir -p $out/bin
    cp -v ecoPCR $out/bin
    cp -v ecogrep $out/bin
    cp -v ecofind $out/bin
    cp -v ../tools/ecoPCRFormat.py $out/bin/ecoPCRFormat
    chmod a+x $out/bin/ecoPCRFormat
  '';

  meta = with lib; {
    description = "Electronic PCR software tool";
    longDescription = ''
      ecoPCR is an electronic PCR software developed by the LECA. It
      helps you estimate Barcode primers quality. In conjunction with
      OBITools, you can postprocess ecoPCR output to compute barcode
      coverage and barcode specificity. New barcode primers can be
      developed using the ecoPrimers software.
    '';
    homepage = "https://git.metabarcoding.org/obitools/ecopcr/wikis/home";
    license = licenses.cecill20;
    maintainers = [ maintainers.metabar ];
  };
}
