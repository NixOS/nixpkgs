{ lib, stdenv, fetchFromGitHub, pkg-config, ocaml, opaline }:

stdenv.mkDerivation rec {
  pname = "ott";
  version = "0.31";

  src = fetchFromGitHub {
    owner = "ott-lang";
    repo = "ott";
    rev = version;
    sha256 = "0l81126i2qkz11fs5yrjdgymnqgjcs5avb7f951h61yh1s68jpnn";
  };

  nativeBuildInputs = [ pkg-config opaline ];
  buildInputs = [ ocaml ];

  installTargets = "ott.install";

  postInstall = ''
    opaline -prefix $out
  ''
  # There is `emacsPackages.ott-mode` for this now.
  + ''
    rm -r $out/share/emacs
  '';

  meta = {
    description = "A tool for the working semanticist";
    longDescription = ''
      Ott is a tool for writing definitions of programming languages and
      calculi. It takes as input a definition of a language syntax and
      semantics, in a concise and readable ASCII notation that is close to
      what one would write in informal mathematics. It generates LaTeX to
      build a typeset version of the definition, and Coq, HOL, and Isabelle
      versions of the definition. Additionally, it can be run as a filter,
      taking a LaTeX/Coq/Isabelle/HOL source file with embedded (symbolic)
      terms of the defined language, parsing them and replacing them by
      target-system terms.
    '';
    homepage = "http://www.cl.cam.ac.uk/~pes20/ott";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jwiegley ];
    platforms = lib.platforms.unix;
  };
}
