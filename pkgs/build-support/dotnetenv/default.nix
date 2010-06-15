{stdenv, dotnetfx}:

{
  buildSolution = import ./build-solution.nix {
    inherit stdenv;
    dotnetfx = dotnetfx.pkg;
  };
  
  inherit (dotnetfx) assembly20Path wcfPath referenceAssembly30Path referenceAssembly35Path;
}
