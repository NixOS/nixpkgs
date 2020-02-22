{ stdenv, fetchFromGitHub, pkgconfig, ocaml }:

stdenv.mkDerivation rec {
  pname = "ott";
  version = "0.30";

  src = fetchFromGitHub {
    owner = "ott-lang";
    repo = "ott";
    rev = version;
    sha256 = "16bxfnm30z94x36vr8vs6zd6fj55vnb7aypjl6hf7clk42040brc";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ocaml ];

  installPhase = ''
    mkdir -p $out/bin
    cp src/ott.opt $out/bin
    ln -s $out/bin/ott.opt $out/bin/ott

    mkdir -p $out/share/emacs/site-lisp
    cp emacs/ott-mode.el $out/share/emacs/site-lisp
    '';

  meta = {
    description = "Ott: tool for the working semanticist";
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
    homepage = http://www.cl.cam.ac.uk/~pes20/ott;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ jwiegley ];
    platforms = stdenv.lib.platforms.unix;
  };
}
