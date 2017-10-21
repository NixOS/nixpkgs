{ stdenv, fetchFromGitHub, emacs, texinfo, texLive, which, automake, enableDoc ? false }:

stdenv.mkDerivation rec {
  name = "ProofGeneral-${version}";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "ProofGeneral";
    repo = "PG";
    rev = "v${version}";
    sha256 = "0bdfk91wf71z80mdfnl8hpinripndcjgdkz854zil6521r84nqk8";
  };

  buildInputs = [ emacs which ] ++ stdenv.lib.optionals enableDoc [ texinfo texLive ];

  prePatch =
    '' sed -i "Makefile" \
           -e "s|^\(\(DEST_\)\?PREFIX\)=.*$|\1=$out|g ; \
               s|/sbin/install-info|install-info|g"

       sed -i "bin/proofgeneral" -e's/which/type -p/g'

       chmod +x bin/proofgeneral

       # @image{ProofGeneral-image} fails, so remove it.
       sed -i '91d' doc/PG-adapting.texi
       sed -i '96d' doc/ProofGeneral.texi
    '' + stdenv.lib.optionalString enableDoc
    # Copy `texinfo.tex' in the right place so that `texi2pdf' works.
    '' cp -v "${automake}/share/"automake-*/texinfo.tex doc
    '';

  patches = [ ./pg.patch ];

  installTargets = [ "install" ] ++ stdenv.lib.optional enableDoc "install-doc";

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
}
