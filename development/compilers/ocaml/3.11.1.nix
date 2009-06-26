args: with args;

stdenv.mkDerivation (rec {
  
  name = "ocaml-3.11.1";
  
  src = fetchurl {
    url = "http://caml.inria.fr/pub/distrib/ocaml-3.11/${name}.tar.bz2";
    sha256 = "8c36a28106d4b683a15c547dfe4cb757a53fa9247579d1cc25bd06a22cc62e50";
  };

  prefixKey = "-prefix ";
  configureFlags = ["-no-tk" "-x11lib" x11];
  buildFlags = "world bootstrap world.opt";
  buildInputs = [x11 ncurses];
  installTargets = "install installopt"; 
  patchPhase = ''
    CAT=$(type -tp cat)
    sed -e "s@/bin/cat@$CAT@" -i config/auto-aux/sharpbang
  '';

  meta = {
    homepage = http://caml.inria.fr/ocaml;
    license = "QPL, LGPL2 (library part)";
    desctiption = "Most popular variant of the Caml language";
  };

})
