{stdenv, fetchurl, tcl, tk, x11, makeWrapper}:

stdenv.mkDerivation {
  name = "wordnet-3.0";
  src = fetchurl {
    url = http://wordnet.princeton.edu/3.0/WordNet-3.0.tar.bz2;
    sha256 = "6c492d0c7b4a40e7674d088191d3aa11f373bb1da60762e098b8ee2dda96ef22";
  };

  buildInputs = [tcl tk x11 makeWrapper];

  # Needs the path to `tclConfig.sh' and `tkConfig.sh'.
  configureFlags = "--with-tcl=" + tcl + "/lib " +
                   "--with-tk="  + tk  + "/lib";

  postInstall = ''
    wrapProgram $out/bin/wishwn --set TK_LIBRARY "${tk}/lib/tk8.4"
    wrapProgram $out/bin/wnb    --prefix PATH : "$out/bin"
  '';

  meta = {
    description = "WordNet, a lexical database for the English language.";
    homepage = http://wordnet.princeton.edu/;
  };
}
