/*

# Updating

To update the list of packages from ELPA,

1. Clone https://github.com/ttuegel/emacs2nix
2. Run `./org-packages.sh` from emacs2nix
3. Copy the new org-packages.json file into Nixpkgs
4. `git commit -m "org-packages $(date -Idate)"`

*/

{ }:

self:

  let

    imported = import ./org-generated.nix {
      inherit (self) callPackage;
    };

    super = imported;

    overrides = {
    };

    orgPackages = super // overrides;

  in orgPackages // { inherit orgPackages; }
