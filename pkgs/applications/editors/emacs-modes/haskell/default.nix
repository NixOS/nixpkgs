{stdenv, fetchurl, emacs}:

stdenv.mkDerivation rec {
  name = "haskell-mode-2.6.1";

  src = fetchurl {
    url = "http://projects.haskell.org/haskellmode-emacs/${name}.tar.gz";
    sha256 = "cc33fd0d4692667a6eb56fea3dc549de3897d8dbb7b71818489760f45d564a76";
  };

  buildInputs = [emacs];

  installPhase = ''
    ensureDir "$out/share/emacs/site-lisp"
    cp *.el *.elc *.hs "$out/share/emacs/site-lisp/"
  '';
}
