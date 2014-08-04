{ stdenv, fetchgit, emacs, pcache, logito }:

stdenv.mkDerivation rec {
  name = "gh-0.5.3";

  src = fetchgit {
    url = "https://github.com/sigma/gh.el.git";
    rev = "ef03b63d063ec22f03af449aa955c98dfad7f80e";
    sha256 = "efa231e0091e8c7785385149dc97b2d8dc24aba65f4b0974b8ed7f62b7596ad3";
  };

  buildInputs = [ emacs ];
  propagatedUserEnvPkgs = [ pcache logito ];

  patchPhase = ''
    sed -i Makefile \
      -e "s|^ *EFLAGS *=|& -L ${pcache}/share/emacs/site-lisp -L ${logito}/share/emacs/site-lisp --eval '(setq user-emacs-directory \"./\")'|" \
      -e "s|/usr/local|$out|" \
      -e "s|/site-lisp/\$(PKGNAME)|/site-lisp|"
  '';

  buildPhase = "make lisp";

  meta = {
    description = "A (very early) GitHub client library for Emacs";
    homepage = https://github.com/sigma/gh.el;
    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.all;
  };
}
