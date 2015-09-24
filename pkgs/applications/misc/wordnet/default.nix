{stdenv, fetchurl, tcl, tk, xlibsWrapper, makeWrapper}:

let version = "3.0"; in
stdenv.mkDerivation {
  name = "wordnet-${version}";
  src = fetchurl {
    url = "http://wordnetcode.princeton.edu/${version}/WordNet-${version}.tar.bz2";
    sha256 = "08pgjvd2vvmqk3h641x63nxp7wqimb9r30889mkyfh2agc62sjbc";
  };

  buildInputs = [tcl tk xlibsWrapper makeWrapper];

  patchPhase = ''
    sed "13i#define USE_INTERP_RESULT 1" -i src/stubs.c
  '';

  # Needs the path to `tclConfig.sh' and `tkConfig.sh'.
  configureFlags = "--with-tcl=" + tcl + "/lib " +
                   "--with-tk="  + tk  + "/lib";

  postInstall = ''
    wrapProgram $out/bin/wishwn --set TK_LIBRARY "${tk}/lib/${tk.libPrefix}"
    wrapProgram $out/bin/wnb    --prefix PATH : "$out/bin"
  '';

  meta = {
    description = "Lexical database for the English language";

    longDescription =
      '' WordNet® is a large lexical database of English.  Nouns, verbs,
         adjectives and adverbs are grouped into sets of cognitive synonyms
         (synsets), each expressing a distinct concept.  Synsets are
         interlinked by means of conceptual-semantic and lexical relations.
         The resulting network of meaningfully related words and concepts can
         be navigated with the browser.  WordNet is also freely and publicly
         available for download.  WordNet's structure makes it a useful tool
         for computational linguistics and natural language processing.
      '';

    homepage = http://wordnet.princeton.edu/;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
