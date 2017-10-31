{stdenv, fetchurl, emacs}:

let version = "1.3.13";

in stdenv.mkDerivation {
  name = "emacs-rainbow-delimiters-${version}";

  src = fetchurl {
    url = "https://github.com/jlr/rainbow-delimiters/archive/${version}.tar.gz";
    sha256 = "075j3nsk4jm0rs5671n28c1wksrfbvpl9a4f89kzcd7sk1h6ncvl";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs -L . --batch -f batch-byte-compile *.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
  '';
}
