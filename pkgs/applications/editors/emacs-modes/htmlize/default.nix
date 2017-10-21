{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "htmlize-1.47";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "htmlize";
    rev = "release/1.47";
    name = "htmlize-1.47-src";
    sha256 = "1vkqxgirc82vc44g7xhhr041arf93yirjin3h144kjyfkgkplnkp";
  };

  installPhase = ''
     mkdir -p $out/share/emacs/site-lisp
     cp htmlize.el $out/share/emacs/site-lisp/
  '';

  meta = {
    description = "Convert buffer text and decorations to HTML";
  };
}
