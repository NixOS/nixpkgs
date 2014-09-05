{ stdenv, fetchurl, emacs, unzip, autoComplete, dash, s }:

stdenv.mkDerivation {
  name = "emacs-ensime-2014-09-04";

  src = fetchurl {
    url = "https://github.com/ensime/ensime-emacs/archive/d3820a3f362975f6e14b817988ec07bfef2b4dad.zip";
    sha256 = "0gwr0r92z2hh2x8g0hpxaar2vvfk1b91cp6v04gaasw0fvl5i7g5";
  };

  buildInputs = [ emacs unzip ];
  propagatedUserEnvPkgs = [ autoComplete dash s ];

  buildPhase = ''
    emacs -L . -L ${autoComplete}/share/emacs/site-lisp --batch -f batch-byte-compile *.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
  '';
}
