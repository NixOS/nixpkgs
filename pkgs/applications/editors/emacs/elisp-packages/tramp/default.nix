{ lib
, stdenv
, fetchurl
, emacs
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "tramp";
  version = "2.5.0";

  src = fetchurl {
    url = "mirror://gnu/tramp/${pname}-${version}.tar.gz";
    sha256 = "sha256-w+6HJA8kFb75Z+7vM1zDnzOnkSSIXKnLVyCcEh+nMGY=";
  };

  buildInputs = [
    emacs
    texinfo
  ];

  meta = {
    homepage = "https://www.gnu.org/software/tramp";
    description = "Transparently access remote files from Emacs. Newer versions than built-in.";
    license = lib.licenses.gpl3Plus;
    inherit (emacs.meta) platforms;
  };
}
