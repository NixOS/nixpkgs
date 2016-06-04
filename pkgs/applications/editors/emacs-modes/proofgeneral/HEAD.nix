{ stdenv, fetchgit, emacs, texinfo, texLive, perl, which, automake, enableDoc ? false }:

stdenv.mkDerivation (rec {
  name = "ProofGeneral-HEAD";

  src = fetchgit {
    url = "https://github.com/ProofGeneral/PG.git";
    rev = "16991280fb09743ae7320aef77f6a166afb907d7";
    sha256 = "1yakjxfz6a09m7lrxff04sj1717gpmhq2bsibd5f9lkp6z0w2i0q";
  };

  buildInputs = [ emacs texinfo perl which ] ++ stdenv.lib.optional enableDoc texLive;

  prePatch =
    '' sed -i "Makefile" \
           -e "s|^\(\(DEST_\)\?PREFIX\)=.*$|\1=$out|g ; \
               s|/sbin/install-info|install-info|g"


       sed -i "bin/proofgeneral" -e's/which/type -p/g'

       # @image{ProofGeneral} fails, so remove it.
       sed -i '94d' doc/PG-adapting.texi
       sed -i '96d' doc/ProofGeneral.texi
    '';

  patches = [ ./pg.patch ];

  preBuild = ''
    make clean;
  '';

  installPhase =
    if enableDoc
    then
    # Copy `texinfo.tex' in the right place so that `texi2pdf' works.
    '' cp -v "${automake}/share/"automake-*/texinfo.tex doc
       make install install-doc
    ''
    else "make install";

  meta = {
    description = "Proof General, an Emacs front-end for proof assistants";
    longDescription = ''
      Proof General is a generic front-end for proof assistants (also known as
      interactive theorem provers), based on the customizable text editor Emacs.
    '';
    homepage = http://proofgeneral.inf.ed.ac.uk;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;  # arbitrary choice
  };
})
