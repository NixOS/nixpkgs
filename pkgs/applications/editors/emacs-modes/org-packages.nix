/*

# Updating

To update the list of packages from Org (ELPA),

1. Run `./update-org`.
2. Check for evaluation errors: `nix-instantiate ../../../.. -A emacsPackagesNg.orgPackages`.
3. `git commit -m "org-packages $(date -Idate)" -- org-generated.nix`

*/

{ lib }:

self: let

  generateOrg = lib.makeOverridable ({
    generated ? ./org-generated.nix
  }: let

    imported = import generated {
      inherit (self) callPackage;
    };

    super = imported;

    overrides = {
    };

  in super // overrides);

in generateOrg { }
