let
  nixpkgs = import ../../..;
  inherit (nixpkgs { system = "x86_64-linux"; }) pkgs lib;
  getEvaluating = x:
    builtins.attrNames (
      lib.filterAttrs (
        _: v: (builtins.tryEval (v.outPath or null)).success && lib.isDerivation v && !v.meta.broken
      ) x
    );
  evaluatingOn-default = getEvaluating pkgs.haskellPackages;
  evaluatingOn-aarch64-darwin = getEvaluating (nixpkgs { system = "aarch64-darwin"; }).haskellPackages;
  evaluatingOn-x86_64-darwin = getEvaluating (nixpkgs { system = "x86_64-darwin"; }).haskellPackages;
  evaluatingOn-aarch64-linux = getEvaluating (nixpkgs { system = "aarch64-linux"; }).haskellPackages;
  unsupported-aarch64 = lib.subtractLists (evaluatingOn-aarch64-darwin ++ evaluatingOn-aarch64-linux) evaluatingOn-x86_64-darwin;
  unsupported-darwin = lib.subtractLists (evaluatingOn-aarch64-darwin ++ evaluatingOn-x86_64-darwin) evaluatingOn-aarch64-linux;
  only-default = lib.subtractLists (evaluatingOn-aarch64-darwin ++ evaluatingOn-x86_64-darwin ++ evaluatingOn-aarch64-linux) evaluatingOn-default;
in
''
  noarm:
  ${lib.concatMapStringsSep "\n" (x: " - ${x}") unsupported-aarch64}
  nodarwin:
  ${lib.concatMapStringsSep "\n" (x: " - ${x}") unsupported-darwin}
  noeverything:
  ${lib.concatMapStringsSep "\n" (x: " - ${x}") only-default}
''
