{ pkgs }:
{
  jupyter-all = pkgs.jupyter.override {
    definitions = {
      clojure = pkgs.clojupyter.definition;
      octave = pkgs.octave-kernel.definition;
      # wolfram = wolfram-for-jupyter-kernel.definition; # unfree
    };
  };

}
