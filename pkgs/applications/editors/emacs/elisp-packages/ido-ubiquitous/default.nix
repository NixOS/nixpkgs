{ stdenv, fetchFromGitHub, emacs }:

let
  version = "3.6-4-gb659bf8";
in
stdenv.mkDerivation {
  pname = "ido-ubiquitous";
  inherit version;

  src = fetchFromGitHub {
    owner = "DarwinAwardWinner";
    repo = "ido-ubiquitous";
    rev = version;
    sha256 = "06r8qpfr60gc673w881m0nplj91b6bfw77bxgl6irz1z9bp7cc4y";
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
