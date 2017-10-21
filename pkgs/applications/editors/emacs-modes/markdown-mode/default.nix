{ stdenv, fetchFromGitHub, emacs }:

let
  version = "2.0-82-gfe30ef7";
in
stdenv.mkDerivation {
  name = "markdown-mode-${version}";

  src = fetchFromGitHub {
    owner  = "defunkt";
    repo   = "markdown-mode";
    rev    = "v${version}";
    sha256 = "14a6r05j0g2ppq2q4kd14qyxwr6yv5jwndavbwzkmp6qhmm9k8nz";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs -L . --batch -f batch-byte-compile *.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
  '';

  meta.license = stdenv.lib.licenses.gpl3Plus;
}
