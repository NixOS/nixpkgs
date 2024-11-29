{ pkgs }:
let
  inherit (pkgs) callPackage;
  icu = pkgs.icu60;
in
{
  ticcutils = callPackage ./ticcutils.nix { };
  libfolia = callPackage ./libfolia.nix { inherit icu; };
  ucto = callPackage ./ucto.nix { inherit icu; };
  uctodata = callPackage ./uctodata.nix { };
  timbl = callPackage ./timbl.nix { };
  timblserver = callPackage ./timblserver.nix { };
  mbt = callPackage ./mbt.nix { };
  frog = callPackage ./frog.nix { inherit icu; };
  frogdata = callPackage ./frogdata.nix { };

  test = callPackage ./test.nix { };
}
