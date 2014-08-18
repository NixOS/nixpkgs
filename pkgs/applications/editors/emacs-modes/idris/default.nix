{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation rec {
  name = "idris-mode-20140405";

  src = fetchgit {
    url = https://github.com/idris-hackers/idris-mode.git;
    rev = "2e2d18fb757da4b42940ebe2a57d7a117175489f";
    sha256 = "d4b52c6c43c038c94a7464cd9c849cd40c01696c440da8b057c00a9be22f9ac0";
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
