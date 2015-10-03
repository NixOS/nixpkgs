{ stdenv, fetchFromGitHub, emacs }:

let
  version = "1.2.0";
in
stdenv.mkDerivation {
  name = "git-modes-${version}";

  src = fetchFromGitHub {
    owner = "magit";
    repo = "git-modes";
    rev = version;
    sha256 = "1ipr51v7nhbbgxbbz0fp3i78ypp73kyxgc4ni8nnr7yirjhsksfd";
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
