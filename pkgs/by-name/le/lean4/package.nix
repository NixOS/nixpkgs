{
  callPackage,
  stdenv,
  con-leche,
  con-ron,
  lean4-unwrapped,
  lean4lean,
  leanPackages,
  nanoda-lib,
}:

let
  lean4Minimal = callPackage ./wrapper.nix {
    variant = "-minimal";
    inherit
      stdenv
      lean4-unwrapped
      ;
  };

  lean4MinimalPackages = leanPackages.overrideScope (
    _: _: {
      lean4 = lean4Minimal;
    }
  );

  kernels = {
    con-leche = con-leche.override { leanPackages = lean4MinimalPackages; };
    inherit con-ron;
    lean4lean = lean4lean.override { leanPackages = lean4MinimalPackages; };
    inherit nanoda-lib;
  };

  lean4 = callPackage ./wrapper.nix {
    extraPackages = builtins.attrValues kernels;
    inherit
      stdenv
      lean4-unwrapped
      ;
    passthru = {
      tests = callPackage ./tests.nix { inherit lean4; };
      inherit kernels;
      minimal = lean4Minimal;
    };
  };
in

lean4
