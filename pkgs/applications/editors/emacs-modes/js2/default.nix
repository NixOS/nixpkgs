{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation {
  name = "js2-mode-0-20140114";

  src = fetchgit {
    url = "git://github.com/mooz/js2-mode.git";
    rev = "b250efaad886dd07b8c69d4573425d095c6652e2";
    sha256 = "30e61e7d364e9175d408bdaf57fda886a4eea22cf5cbd97abb5c307c52b05918";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs --batch -f batch-byte-compile js2-mode.el
  '';

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    cp js2-mode.el js2-mode.elc $out/share/emacs/site-lisp/
  '';
}
