/*

# New packages

READ THIS FIRST

This module is for the MauiKit framework and official Maui applications. All
available packages are listed in `callPackage ./srcs.nix`, although some are not yet
packaged in Nixpkgs.

IF YOUR PACKAGE IS NOT LISTED IN `callPackage ./srcs.nix`, IT DOES NOT GO HERE.

See also `pkgs/applications/kde` as this is what this is based on.

# Updates

1. Update the URL in `callPackage ./fetch.sh`.
2. Run `callPackage ./maintainers/scripts/fetch-kde-qt.sh pkgs/applications/maui`
   from the top of the Nixpkgs tree.
3. Use `nixpkgs-review wip` to check that everything builds.
4. Commit the changes and open a pull request.

*/

{ lib
, libsForQt5
, fetchurl
}:

let
  minQtVersion = "5.15";
  broken = lib.versionOlder libsForQt5.qtbase.version minQtVersion;

  mirror = "mirror://kde";
  srcs = import ./srcs.nix { inherit fetchurl mirror; };

  mkDerivation = args:
    let
      inherit (args) pname;
      inherit (srcs.${pname}) src version;
      mkDerivation =
        libsForQt5.callPackage ({ mkDerivation }: mkDerivation) {};
    in
      mkDerivation (args // {
        inherit pname version src;

        outputs = args.outputs or [ "out" ];

        meta =
          let meta = args.meta or {}; in
          meta // {
            homepage = meta.homepage or "https://mauikit.org/";
            platforms = meta.platforms or lib.platforms.linux;
            broken = meta.broken or broken;
          };
      });

  packages = self: with self;
    let
      callPackage = self.newScope {
        inherit mkDerivation;
      };
    in {
      # libraries
      mauikit = callPackage ./mauikit.nix { };
      mauikit-accounts = callPackage ./mauikit-accounts.nix { };
      mauikit-filebrowsing = callPackage ./mauikit-filebrowsing.nix { };
      mauikit-imagetools = callPackage ./mauikit-imagetools.nix { };
      mauikit-texteditor = callPackage ./mauikit-texteditor.nix { };

      # applications
      buho = callPackage ./buho.nix { };
      clip = callPackage ./clip.nix { };
      communicator = callPackage ./communicator.nix { };
      index = callPackage ./index.nix { };
      nota = callPackage ./nota.nix { };
      pix = callPackage ./pix.nix { };
      shelf = callPackage ./shelf.nix { };
      vvave = callPackage ./vvave.nix { };
    };

in lib.makeScope libsForQt5.newScope packages
