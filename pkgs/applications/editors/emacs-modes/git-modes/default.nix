{ stdenv, fetchFromGitHub, emacs }:

let
  version = "0.15.0-8-g4e10851";
in
stdenv.mkDerivation {
  name = "git-modes-${version}";

  src = fetchFromGitHub {
    owner = "magit";
    repo = "git-modes";
    rev = "4e10851843145e0c05fc665683d3b487a57ad114";
    sha256 = "13j794a2p4ql9dnw2z0c1m0ybclxsicbk8cmmfqcchs4ygiyc6ag";
  };

  buildInputs = [ emacs ];

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    mv *.el *.elc $out/share/emacs/site-lisp/
  '';

  meta = {
    homepage = "https://github.com/magit/git-modes";
    description = "Emacs modes for various Git-related files";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ simons ];
  };
}
