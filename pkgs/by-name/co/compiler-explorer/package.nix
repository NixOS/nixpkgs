{ callPackage, gcc13, nodejs, ... } @ args:
let
  unwrapped = callPackage ./unwrapped.nix (removeAttrs args [ "callPackage" ]);
in
  unwrapped.overrideAttrs (oldAttrs: {
    passthru = oldAttrs.passthru // {
      withCompilers = func: callPackage ./wrapper.nix {
        compiler-explorer = unwrapped;
        compiler-explorer-compilers = {gcc = [gcc13];};
        nodejs = nodejs;
      };
    };
  })
