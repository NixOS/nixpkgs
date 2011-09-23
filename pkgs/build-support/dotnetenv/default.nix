{stdenv, dotnetfx}:

let dotnetenv =
{
  buildSolution = import ./build-solution.nix {
    inherit stdenv;
    dotnetfx = dotnetfx.pkg;
  };

  buildWrapper = import ./wrapper.nix {
    inherit dotnetenv;
  };
  
  inherit (dotnetfx) assembly20Path wcfPath referenceAssembly30Path referenceAssembly35Path;
};
in
dotnetenv
