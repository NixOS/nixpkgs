{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "image";
  version = "2.16.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-m7JsyljrH77fs/hOPS5+HuteFtfr4yNbfBB9lPWNFBc=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/image/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Functions for processing images";
    longDescription = ''
      The Octave-forge Image package provides functions for processing
      images. The package also provides functions for feature extraction,
      image statistics, spatial and geometric transformations, morphological
      operations, linear filtering, and much more.
    '';
  };
}
