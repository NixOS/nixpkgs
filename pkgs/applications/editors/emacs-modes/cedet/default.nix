{ fetchurl, stdenv, emacs, python }:

stdenv.mkDerivation rec {
  name = "cedet-1.1";

  src = fetchurl {
    url = "mirror://sourceforge/cedet/${name}.tar.gz";
    sha256 = "0p2bwlpwwa019axvgj09xkxbr53j0pq23d46s4la9jfhl47nbh22";
  };

  buildInputs = [ emacs python ];

  doCheck = true;
  checkPhase = "make utest";

  installPhase = ''
    mkdir -p "$out/share/emacs/site-lisp"
    cp -v */*.el */*/*.el */*.elc */*/*.elc "$out/share/emacs/site-lisp"
    chmod a-x "$out/share/emacs/site-lisp/"*

    mkdir -p "$out/share/info"
    cp -v */*.info* */*/*.info* "$out/share/info"
  '';

  meta = {
    description = "CEDET, a Collection of Emacs Development Environment Tools";

    longDescription = ''
      CEDET is a collection of tools written with the end goal of
      creating an advanced development environment in Emacs.

      Emacs already is a great environment for writing software, but
      there are additional areas that need improvement.  Many new
      ideas for integrated environments have been developed in newer
      products, such as JBuilder, Eclipse, or KDevelop.  CEDET is a
      project which brings together several different tools needed to
      implement advanced features.

      CEDET includes EIEIO (Enhanced Implementation of Emacs
      Interpreted Objects), Semantic, SRecode, Speedbar, EDE (Emacs
      Development Environment), and COGRE (COnnected GRaph Editor).
    '';

    license = stdenv.lib.licenses.gpl2Plus;

    homepage = http://cedet.sourceforge.net/;
  };
}
