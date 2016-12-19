{stdenv, vs}:

{
  buildSolution = import ./build-solution.nix {
    inherit stdenv vs;
  };  
}
