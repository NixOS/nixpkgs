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
            homepage = meta.homepage or "https://www.plasma-mobile.org/";
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
      alligator = callPackage ./alligator.nix {};
      angelfish = callPackage ./angelfish.nix { inherit srcs; };
      audiotube = callPackage ./audiotube.nix {};
      calindori = callPackage ./calindori.nix {};
      kalk = callPackage ./kalk.nix {};
      kasts = callPackage ./kasts.nix {};
      kclock = callPackage ./kclock.nix {};
      keysmith = callPackage ./keysmith.nix {};
      koko = callPackage ./koko.nix {};
      krecorder = callPackage ./krecorder.nix {};
      ktrip = callPackage ./ktrip.nix {};
      kweather = callPackage ./kweather.nix {};
      neochat = callPackage ./neochat.nix { inherit srcs; };
      plasma-dialer = callPackage ./plasma-dialer.nix {};
      plasma-phonebook = callPackage ./plasma-phonebook.nix {};
      plasma-settings = callPackage ./plasma-settings.nix {};
      plasmatube = callPackage ./plasmatube {};
      spacebar = callPackage ./spacebar.nix { inherit srcs; };
    };

in lib.makeScope libsForQt5.newScope packages
