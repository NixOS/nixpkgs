{ stdenv, fetchsvn }:

stdenv.mkDerivation rec {
  pname = "hol_light-mode";
  version = "73";

  src = fetchsvn {
    url = http://seanmcl-ocaml-lib.googlecode.com/svn/trunk/workshop/software/emacs;
    rev = version;
    sha256 = "3ca83098960439da149a47e1caff32536601559a77f04822be742a390c67feb7";
  };

  installPhase = ''
    DEST=$out/share/emacs/site-lisp
    mkdir -p $DEST
    cp -a * $DEST
  '';

  meta = {
    description = "A HOL Light mode for Emacs";
    homepage    = http://www.cl.cam.ac.uk/~jrh13/hol-light/;
    license     = stdenv.lib.licenses.gpl2Plus;
    platforms   = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];

    # Fails trying to fetch dependencies in build
    # broken = true;
  };
}
