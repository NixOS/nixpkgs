{stdenv, fetchurl}:

let
    version = "0.2-4";
in
stdenv.mkDerivation
{
  name = "rudel-${version}";
  src = fetchurl
  {
    url = "mirror://sourceforge/rudel/rudel-${version}.tar.gz";
    sha256 = "68247bfb702d929877f6d098932e8b0ca45c573a3510187e1ccc43e5ea194f25";
  };

  installPhase = ''
    for n in . obby zeroconf jupiter; do
      mkdir -p "$out/share/emacs/site-lisp/$n";
      cp $n/*.el "$out/share/emacs/site-lisp/$n/";
    done
    install -D -m444 doc/card.pdf "$out/share/doc/rudel/card.pdf"
  '';

  meta = {
    homepage = http://rudel.sourceforge.net/;
    description = "A collaborative editing environment for GNU Emacs";
    license = "GPL";
  };
}
