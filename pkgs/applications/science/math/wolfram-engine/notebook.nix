{ stdenv, writeScriptBin, jupyter, wolfram-for-jupyter-kernel }:

let
  wolfram-jupyter = jupyter.override { definitions = { wolfram = wolfram-for-jupyter-kernel.definition; }; };
in
  writeScriptBin "wolfram-notebook" ''
    #! ${stdenv.shell}
    ${wolfram-jupyter}/bin/jupyter-notebook
  ''
