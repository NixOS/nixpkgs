{stdenv, fetchurl, emacs}:

stdenv.mkDerivation rec {
  name = "haskell-mode-2.7.0";

  src = fetchurl {
    url = "http://projects.haskell.org/haskellmode-emacs/${name}.tar.gz";
    sha256 = "8b45c55ed5f2b498529a6d7e01b77fea899c1de93e24653cab188cb3a4f495bc";
  };

  buildInputs = [emacs];

  installPhase = ''
    ensureDir "$out/share/emacs/site-lisp"
    cp *.el *.elc *.hs "$out/share/emacs/site-lisp/"
  '';
}
