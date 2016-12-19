{ stdenv, fetchgit, emacs, gh, pcache, logito }:

stdenv.mkDerivation rec {
  name = "gist-1.0";

  src = fetchgit {
    url = "https://github.com/sigma/gist.el.git";
    rev = "bbb457e4eaaf5f96cfaaa4f63021e3e542bfbfed";
    sha256 = "469f9df52076d0c6038183cff4b9415bca98de66c08814a60b69729b44bdf294";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs -L ${gh}/share/emacs/site-lisp \
          -L ${pcache}/share/emacs/site-lisp \
          -L ${logito}/share/emacs/site-lisp \
          --eval '(setq user-emacs-directory "./")' \
          --batch -f batch-byte-compile gist.el
  '';

  propagatedUserEnvPkgs = [ gh pcache logito ];

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install gist.el gist.elc $out/share/emacs/site-lisp
  '';

  meta = {
    description = "Emacs integration for gist.github.com";
    homepage = https://github.com/sigma/gist.el;
    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.all;
  };
}
