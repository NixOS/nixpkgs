{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation rec {
  name = "idris-mode-20140223";

  src = fetchgit {
    url = https://github.com/idris-hackers/idris-mode.git;
    rev = "486470533e74c55192e92a1afa050475915ee1e7";
    sha256 = "ff2e6bd8fbf421e8f2db0789d2ff56c5103775b911b99bab64e4652d332bad43";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs -L . --batch -f batch-byte-compile *.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Emacs major mode for Idris";
    homepage = https://github.com/idris-hackers/idris-mode;
    license = "GPLv3";

    platforms = stdenv.lib.platforms.all;
  };
}
