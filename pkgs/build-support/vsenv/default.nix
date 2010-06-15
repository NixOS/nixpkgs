{stdenv, vs}:

{
  buildSolution = import ./buildSolution.nix {
    inherit stdenv vs;
  };  
}
