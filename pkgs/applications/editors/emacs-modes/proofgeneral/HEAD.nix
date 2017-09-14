{ stdenv, fetchFromGitHub, emacs, texinfo, texLive, perl, which, automake, enableDoc ? false }:

stdenv.mkDerivation (rec {
  name = "ProofGeneral-unstable-${version}";
  version = "2017-05-06";

  src = fetchFromGitHub {
    owner = "ProofGeneral";
    repo = "PG";
    rev = "574b0992e3cb4b7a4ad88400b9a5ab0198a96ca5";
    sha256 = "1c1pgdmy58h78s53g0ga9b5ilbsibz0dr2lk52xgbs3q5m22v5fh";
  };

  buildInputs = [ emacs texinfo perl which ] ++ stdenv.lib.optional enableDoc texLive;

  prePatch =
    '' sed -i "Makefile" \
           -e "s|^\(\(DEST_\)\?PREFIX\)=.*$|\1=$out|g ; \
               s|/sbin/install-info|install-info|g"

       # @image{ProofGeneral} fails, so remove it.
       sed -i '94d' doc/PG-adapting.texi
       sed -i '96d' doc/ProofGeneral.texi
    '';

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
