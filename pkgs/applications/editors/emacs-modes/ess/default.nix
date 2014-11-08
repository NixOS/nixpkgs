{ stdenv, fetchurl, emacs, texinfo }:

stdenv.mkDerivation rec {
  name = "ess-14.09";

  src = fetchurl {
    url = "http://ess.r-project.org/downloads/ess/${name}.tgz";
    sha256 = "0mk8b5i5pxyqj2i5bn6kspxq4l4i9ql84wmxvvaax9jvfgzcml0y";
  };

  buildInputs = [ emacs texinfo ];

  configurePhase = "makeFlags=PREFIX=$out";

  meta = {
    description = "Emacs Speaks Statistics";
    homepage = "http://ess.r-project.org/";
    license = stdenv.lib.licenses.gpl2Plus;
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
