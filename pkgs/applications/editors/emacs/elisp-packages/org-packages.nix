/*

# Updating

To update the list of packages from Org (ELPA),

1. Run `./update-org`.
2. Check for evaluation errors:
     env NIXPKGS_ALLOW_BROKEN=1 nix-instantiate ../../../../.. -A emacs.pkgs.orgPackages
3. Run `git commit -m "org-packages $(date -Idate)" -- org-generated.nix`

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
