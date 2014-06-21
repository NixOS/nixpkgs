{ stdenv, fetchurl, emacs, texinfo, texLive, perl, which, automake }:

stdenv.mkDerivation (rec {
  name = "ProofGeneral-4.2";

  src = fetchurl {
    url = http://proofgeneral.inf.ed.ac.uk/releases/ProofGeneral-4.2.tgz;
    sha256 = "09qb0myq66fw17v4ziz401ilsb5xlxz1nl2wsp69d0vrfy0bcrrm";
  };

  sourceRoot = name;

  buildInputs = [ emacs texinfo texLive perl which ];

  prePatch =
    '' sed -i "Makefile" \
           -e "s|^\(\(DEST_\)\?PREFIX\)=.*$|\1=$out|g ; \
               s|/sbin/install-info|install-info|g"


       # Workaround for bug #458 
       # ProofGeneral 4.2 byte-compilation fails with Emacs 24.2.90
       # http://proofgeneral.inf.ed.ac.uk/trac/ticket/458
       sed -i "Makefile" \
       	   -e "s|(setq byte-compile-error-on-warn t)||g"

       sed -i "bin/proofgeneral" -e's/which/type -p/g'

       # @image{ProofGeneral} fails, so remove it.
       sed -i '94d' doc/PG-adapting.texi
       sed -i '101d' doc/ProofGeneral.texi
    '';

  preBuild = ''
    make clean;
  '';

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
    platforms = stdenv.lib.platforms.unix;  # arbitrary choice
  };
})
