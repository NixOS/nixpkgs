{stdenv, fetchurl, emacs}:

stdenv.mkDerivation
{
  name = "maude-mode-0.1";
  src = fetchurl
  {
    url = "mirror://sourceforge/maude-mode/maude-mode.tar.gz";
    sha256 = "12555j01mar48da2jy3ay93xfn7ybl23bpvhp0srzg8858gisx5g";
  };
  buildInputs = [emacs];
  configureFlags = "--with-lispdir=$$out/share/emacs/site-lisp";
}
