{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "safefile";
  version = "1.0.5";

  src = fetchurl {
    url = "http://research.cs.wisc.edu/mist/safefile/releases/safefile-${finalAttrs.version}.tar.gz";
    sha256 = "1y0gikds2nr8jk8smhrl617njk23ymmpxyjb2j1xbj0k82xspv78";
  };

  meta = {
    description = "File open routines to safely open a file when in the presence of an attack";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.all;
    homepage = "https://research.cs.wisc.edu/mist/safefile/";
  };
})
