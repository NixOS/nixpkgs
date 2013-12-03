{ stdenv, fetchurl, emacs, texinfo }:

stdenv.mkDerivation rec {
  name = "ess-13.09";

  src = fetchurl {
    url = "http://ess.r-project.org/downloads/ess/${name}.tgz";
    sha256 = "1lki3vb6p7cw98zqq0gaia68flpqrjkd6dcl85fs0cc8qf55yqnh";
  };

  buildInputs = [ emacs texinfo ];

  configurePhase = "makeFlags=PREFIX=$out";

  meta = {
    description = "Emacs Speaks Statistics";
    homepage = "http://ess.r-project.org/";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
