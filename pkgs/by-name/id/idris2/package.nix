{
  lib,
  newScope,
  fetchFromGitHub,
}:
let
  idris2CompilerPackages = lib.makeScope newScope (
    self:
    let
      inherit (self) callPackage;
    in
    {
      # Compiler version & repo
      idris2-version = "0.8.0";
      idris2-src = fetchFromGitHub {
        owner = "idris-lang";
        repo = "Idris2";
        rev = "v${self.idris2-version}";
        hash = "sha256-MvFNSPpgONSTjACH3HGWEiNgz9aAeBPmyQwFe21+fe0=";
      };
      # Prelude libraries
      mkPrelude = callPackage ./mkPrelude.nix { }; # Build helper
      prelude = callPackage ./prelude.nix { };
      base = callPackage ./base.nix { };
      linear = callPackage ./linear.nix { };
      network = callPackage ./network.nix { };
      contrib = callPackage ./contrib.nix { };
      test = callPackage ./test.nix { };

      libidris2_support = callPackage ./libidris2_support.nix { };
      idris2-unwrapped = callPackage ./unwrapped.nix { };
    }
  );
in
idris2CompilerPackages.idris2-unwrapped.withPackages (_: [ ])
