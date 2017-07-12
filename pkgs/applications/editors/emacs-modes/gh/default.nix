{ stdenv, fetchFromGitHub, emacs, pcache, logito }:

stdenv.mkDerivation rec {
  name = "gh-0.5.3";

  src = fetchFromGitHub {
    owner = "sigma";
    repo = "gh.el";
    rev = "ef03b63d063ec22f03af449aa955c98dfad7f80e";
    sha256 = "11hrfqp8i04l91kn6gfnz7xc62g7ff44sh1cvkmvlmn0y5j7glr1";
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
