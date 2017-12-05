{ stdenv, fetchurl, emacs, texinfo }:

stdenv.mkDerivation rec {
  name = "ess-14.09";

  src = fetchurl {
    url = "http://ess.r-project.org/downloads/ess/${name}.tgz";
    sha256 = "0wa507jfmq3k7x0vigd2yzb4j2190ix4wnnpv7ql4bjy0vfvmwdn";
  };

  buildInputs = [ emacs texinfo ];

  configurePhase = "makeFlags=PREFIX=$out";

  meta = {
    description = "Emacs Speaks Statistics";
    homepage = http://ess.r-project.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
