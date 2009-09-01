{stdenv, fetchsvn}: 
stdenv.mkDerivation {
  name = "stratego-mode";
  builder = ./builder.sh;
  src = fetchsvn {
    url = https://svn.strategoxt.org/repos/StrategoXT/stratego-editors/trunk/emacs/stratego.el;
    rev = 12678;
    sha256 = "4ab4ec587550233f29ca08b82fa0a9f7e5b33fc178348037e3ab1816bd60f538";
  };
}
