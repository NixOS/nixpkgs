{
  lib,
  stdenv,
  fetchurl,
  gcc,
  zlib,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "ecopcr";
  version = "1.0.1";

  src = fetchurl {
    url = "https://git.metabarcoding.org/obitools/ecopcr/-/archive/ecopcr_v${version}/ecopcr-ecopcr_v${version}.tar.gz";
    hash = "sha256-ssvWpi7HuuRRAkpqqrX3ijLuBqM3QsrmrG+t7/m6fZA=";
  };

  patches = [
    ./gcc14.patch
  ];

  buildInputs = [
    gcc
    python3
    zlib
  ];

  preConfigure = ''
    cd src
  '';

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
    maintainers = [ ];
  };
}
