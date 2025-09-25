{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation {
  pname = "freetxl";
  version = "10.8b";

  src = fetchurl {
    url =
      if stdenv.hostPlatform.isDarwin then
        "https://txl.ca/download/378-txl10.8b.macosx64.tar.gz"
      else
        "https://txl.ca/download/319-txl10.8b.linux64.tar.gz";

    sha256 =
      if stdenv.hostPlatform.isDarwin then
        "sha256-i1iUx65Le6JRLkn/Y2kD0u+4/gDBJxt36pdR1fE4zNs="
      else
        "sha256-xEPuxEuliMhn6DkSle13OjMP4ResM4RYjnmVoDpxHNk=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/{bin,lib,share/man}
    cp ./bin/* $out/bin
    cp ./lib/* $out/lib
    cp -r ./man/* $out/share/man
  '';

  meta = {
    description = "Rule-based language for structural analysis, source transformation, and programming language prototyping";
    longDescription = ''
      Txl is a unique programming language specifically designed to support computer software analysis and source transformation tasks. It is the evolving result of more than fifteen years of concentrated research on rule-based structural transformation as a paradigm for the rapid solution of complex computing problems.

      The Txl programming language is a hybrid functional / rule-based language with unification, implied iteration and deep pattern match.

      Each Txl program has two components:

      - A Description of the Structures to be Transformed\
        Specified as a directly interpreted BNF grammar, in context-free ambiguous form.

      - A Set of Structural Transformation Rules\
        Specified as pattern/replacement pairs, combined using functional programming.

      Txl is unique in that it is has a pure functional superstructure that provides scoping, abstraction, parameterization and recursion, over Prolog-like structural rewriting rules providing pattern search, unification and implicit iteration.

      The formal semantics and implementation of Txl are based on formal tree rewriting, but the trees are largely hidden from the user due to the by-example style of rule specification.
    '';
    homepage = "https://txl.ca/";
    downloadPage = "https://txl.ca/txl-download.html";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "txl";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [ MysteryBlokHed ];
  };
}
