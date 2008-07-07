{stdenv, fetchurl, emacs}:

stdenv.mkDerivation rec
{
  name = "haskell-mode-2.4";
  src = fetchurl
  {
    url = "http://www.iro.umontreal.ca/~monnier/elisp/${name}.tar.gz";
    sha256 = "1s2dd0clwm0qaq7z43vxx437l48c88yrd3z1a6qhbq8aak9y8jc5";
  };
  buildInputs = [emacs];
  installCommand =
  ''
    ensureDir "$out/share/emacs/site-lisp"
    cp *.el *.elc *.hs "$out/share/emacs/site-lisp/"
  '';
}
