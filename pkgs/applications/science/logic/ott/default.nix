{ lib, stdenv, fetchFromGitHub, pkg-config, ocamlPackages, opaline }:

stdenv.mkDerivation rec {
  pname = "ott";
  version = "0.33";

  src = fetchFromGitHub {
    owner = "ott-lang";
    repo = "ott";
    rev = version;
    hash = "sha256-GzeEiok5kigcmfqf/K/UxvlKkl55zy0vOyiRZ2HyMiE=";
  };


  strictDeps = true;

  nativeBuildInputs = [ pkg-config opaline ] ++ (with ocamlPackages; [ findlib ocaml ]);
  buildInputs = with ocamlPackages; [ ocamlgraph ];

  installTargets = "ott.install";

  postInstall = ''
    opaline -prefix $out
  ''
  # There is `emacsPackages.ott-mode` for this now.
  + ''
    rm -r $out/share/emacs
  '';

  meta = {
    description = "Tool for the working semanticist";
    mainProgram = "ott";
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
