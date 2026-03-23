{ lib, callPackage, ... }@args:

let
  common = opts: callPackage (import ./builder.nix lib opts);
  extraArgs = removeAttrs args [ "callPackage" ];
in
rec {
  rke2_1_32 = common (import ./1_32/versions.nix) extraArgs;

  rke2_1_33 = common (import ./1_33/versions.nix) extraArgs;

  rke2_1_34 = common (import ./1_34/versions.nix) extraArgs;

  rke2_1_35 = common (import ./1_35/versions.nix) extraArgs;

  # Automatically set by update script, changes shouldn't be backported
  rke2_stable = rke2_1_34;
  rke2_latest = rke2_1_35;
}
