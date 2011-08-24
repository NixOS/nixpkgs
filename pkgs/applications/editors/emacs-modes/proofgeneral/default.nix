{ stdenv, fetchurl, emacs, texinfo, texLive, perl, which, automake }:

stdenv.mkDerivation (rec {
  name = "ProofGeneral-4.0";

  src = fetchurl {
    url = http://proofgeneral.inf.ed.ac.uk/releases/ProofGeneral-4.0.tgz;
    sha256 = "1ang2lsc97vl70fkgypfsr1ivdzsdliq3bkvympj30wnc7ayzbmq";
  };

  sourceRoot = name;

  buildInputs = [ emacs texinfo texLive perl which ];

  patches = [ ./emacs-23.3.patch ];

  postPatch =
    '' sed -i "Makefile" \
           -e "s|^\(\(DEST_\)\?PREFIX\)=.*$|\1=$out|g ; \
               s|/sbin/install-info|install-info|g"

       sed -i "bin/proofgeneral" -e's/which/type -p/g'
    '';

  preBuild = "make clean";

  installPhase =
    # Copy `texinfo.tex' in the right place so that `texi2pdf' works.
    '' cp -v "${automake}/share/"automake-*/texinfo.tex doc
       make install install-doc
    '';

  meta = {
    description = "Proof General, an Emacs front-end for proof assistants";
    longDescription = ''
      Proof General is a generic front-end for proof assistants (also known as
      interactive theorem provers), based on the customizable text editor Emacs.
    '';
    homepage = http://proofgeneral.inf.ed.ac.uk;
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
})
