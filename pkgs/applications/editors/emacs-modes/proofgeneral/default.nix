{ stdenv, fetchurl, emacs, texinfo, texLive, perl, which, automake }:

let
  pname = "ProofGeneral";
  version = "3.7.1.1";
  name = "${pname}-${version}";
  website = "http://proofgeneral.inf.ed.ac.uk";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://www.cl.cam.ac.uk/research/hvg/Isabelle/dist/contrib/${name}.tar.gz";
    sha256 = "ae430590d6763618df50a662a37f0627d3c3c8f31372f6f0bb2116b738fc92d8";
  };

  sourceRoot = name;

  buildInputs = [ emacs texinfo texLive perl which ];

  patchPhase =
    '' sed -i "Makefile" \
           -e "s|^\(\(DEST_\)\?PREFIX\)=.*$|\1=$out|g ; \
               s|/sbin/install-info|install-info|g"

       sed -i "bin/proofgeneral" -e's/which/type -p/g'
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
    homepage = website;
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
