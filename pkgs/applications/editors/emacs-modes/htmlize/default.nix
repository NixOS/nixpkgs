{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "htmlize-1.47";

  src = fetchurl {
    url = https://raw.githubusercontent.com/emacsmirror/htmlize/master/htmlize.el;
    sha256 = "0m7lby95w9sj0xlqv39imlbp80x8ajd295cs6079jyhmryf6mr10";
  };

  unpackPhase = ":;";
    
  installPhase = ''
     mkdir -p $out/share/emacs/site-lisp
     cp $src $out/share/emacs/site-lisp/htmlize.el
  '';

  meta = {
    description = "Convert buffer text and decorations to HTML";
  };
}
