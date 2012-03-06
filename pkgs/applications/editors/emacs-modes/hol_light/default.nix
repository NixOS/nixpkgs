{stdenv, fetchsvn}:

let
  revision = "73";
in

stdenv.mkDerivation {
  name = "hol_light_mode-${revision}";

  src = fetchsvn {
    url = http://seanmcl-ocaml-lib.googlecode.com/svn/trunk/workshop/software/emacs;
    rev = revision;
    sha256 = "3ca83098960439da149a47e1caff32536601559a77f04822be742a390c67feb7";
  };

  installPhase = ''
    DEST=$out/share/emacs/site-lisp
    mkdir -p $DEST
    cp -a * $DEST
  '';

  meta = {
    description = "A HOL Light mode for emacs";
  };
}
