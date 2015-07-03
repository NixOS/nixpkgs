{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "htmlize-1.47";

  src = fetchurl {
    url = https://github.com/emacsmirror/htmlize/archive/release/1.47.tar.gz;
    sha256 = "1l5idp957z4zq6az06ljb48qkfnciihdi8k347p46mdfdbh5akv0";
  };

  installPhase = ''
     mkdir -p $out/share/emacs/site-lisp
     cp htmlize.el $out/share/emacs/site-lisp/
  '';

  meta = {
    description = "Convert buffer text and decorations to HTML";
  };
}
