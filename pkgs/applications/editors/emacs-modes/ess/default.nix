{ stdenv, fetchurl, emacs, texinfo }:

stdenv.mkDerivation {
  name = "ess-13.05";

  src = fetchurl {
    url = "http://ess.r-project.org/downloads/ess/ess-13.05.tgz";
    sha256 = "007rd8hg1aclr2i8178ym5c4bi7vgmwkp802v1mkgr85h50zlfdk";
  };

  buildInputs = [ emacs texinfo ];

  configurePhase = "makeFlags=PREFIX=$out";

  meta = {
    description = "Emacs Speaks Statistics";
    homepage = "http://ess.r-project.org/";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
