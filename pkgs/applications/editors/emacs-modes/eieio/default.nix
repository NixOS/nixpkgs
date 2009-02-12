{ fetchurl, stdenv, emacs }:

stdenv.mkDerivation rec {
  name = "eieio-0.17";

  src = fetchurl {
    url = "mirror://sourceforge/cedet/${name}.tar.gz";
    sha256 = "0n31z9d47ar10g9xrnzz3nl4pmixw1nkk0kpxaillls7xvjd1zy2";
  };

  buildInputs = [ emacs ];

  doCheck = false;
  checkPhase = "make test";

  installPhase = ''
    ensureDir "$out/share/emacs/site-lisp"
    cp -v *.el *.elc "$out/share/emacs/site-lisp"
    chmod a-x "$out/share/emacs/site-lisp/"*

    ensureDir "$out/share/info"
    cp -v *.info* "$out/share/info"
  '';

  meta = {
    description = "EIEIO: Enhanced Implementation of Emacs Interpreted Objects";

    longDescription = ''
      EIEIO is a package which implements a CLOS subset for Emacs.  It
      includes examples which can draw simple tree graphs, and bar
      charts.
    '';

    license = "GPLv2+";

    homepage = http://cedet.sourceforge.net/;
  };
}
