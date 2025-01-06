/*
  # New packages

  READ THIS FIRST

  This module is for official packages in the Plasma Mobile Gear. All
  available packages are listed in `./srcs.nix`, although some are not yet
  packaged in Nixpkgs.

  IF YOUR PACKAGE IS NOT LISTED IN `./srcs.nix`, IT DOES NOT GO HERE.

  See also `pkgs/applications/kde` as this is what this is based on.

  # Updates

  1. Update the URL in `./fetch.sh`.
  2. Run `./maintainers/scripts/fetch-kde-qt.sh pkgs/applications/plasma-mobile`
     from the top of the Nixpkgs tree.
  3. Use `nox-review wip` to check that everything builds.
  4. Commit the changes and open a pull request.
*/

{
  lib,
  libsForQt5,
  fetchurl,
}:

let
  mirror = "mirror://kde";
  srcs = import ./srcs.nix { inherit fetchurl mirror; };

  mkDerivation =
    args:
    let
      inherit (args) pname;
      inherit (srcs.${pname}) src version;
      mkDerivation = libsForQt5.callPackage ({ mkDerivation }: mkDerivation) { };
    in
    mkDerivation (
      args
      // {
        inherit pname version src;

        outputs = args.outputs or [ "out" ];

        meta =
          let
            meta = args.meta or { };
          in
          meta
          // {
            homepage = meta.homepage or "https://www.plasma-mobile.org/";
            platforms = meta.platforms or lib.platforms.linux;
          };
      }
    );

  packages =
    self:
    let
      callPackage = self.newScope {
        inherit mkDerivation;
      };
    in
    {
      plasma-dialer = callPackage ./plasma-dialer.nix { };
      plasma-phonebook = callPackage ./plasma-phonebook.nix { };
      plasma-settings = callPackage ./plasma-settings.nix { };
      spacebar = callPackage ./spacebar.nix { };
    };

in
lib.makeScope libsForQt5.newScope packages
