/*

# New packages

READ THIS FIRST

This module is for official packages in the KDE Applications Bundle. All
available packages are listed in `./srcs.nix`, although some are not yet
packaged in Nixpkgs (see below).

IF YOUR PACKAGE IS NOT LISTED IN `./srcs.nix`, IT DOES NOT GO HERE.

Many of the packages released upstream are not yet built in Nixpkgs due to lack
of demand. To add a Nixpkgs build for an upstream package, copy one of the
existing packages here and modify it as necessary. A simple example package that
still shows most of the available features is in `./gwenview.nix`.

# Updates

1. Update the URL in `./fetch.sh`.
2. Run `./maintainers/scripts/fetch-kde-qt.sh pkgs/desktops/kde-5/applications`
   from the top of the Nixpkgs tree.
3. Use `nox-review wip` to check that everything builds.
4. Commit the changes and open a pull request.

*/

{
  stdenv, lib, libsForQt5, fetchurl, recurseIntoAttrs,
  kdeDerivation, plasma5,
  attica, phonon,
  debug ? false,
}:

let
  mirror = "mirror://kde";
  srcs = import ./srcs.nix { inherit fetchurl mirror; };
in

let

  packages = self: with self;
    let
      callPackage = self.newScope {
        kdeApp = import ./build-support/application.nix {
          inherit lib kdeDerivation;
          inherit debug srcs;
        };
      };
    in {
      kdelibs = callPackage ./kdelibs { inherit attica phonon; };
      akonadi = callPackage ./akonadi.nix {};
      akonadi-contacts = callPackage ./akonadi-contacts.nix {};
      akonadi-mime = callPackage ./akonadi-mime.nix {};
      ark = callPackage ./ark/default.nix {};
      baloo-widgets = callPackage ./baloo-widgets.nix {};
      dolphin = callPackage ./dolphin.nix {};
      dolphin-plugins = callPackage ./dolphin-plugins.nix {};
      ffmpegthumbs = callPackage ./ffmpegthumbs.nix { };
      filelight = callPackage ./filelight.nix {};
      gwenview = callPackage ./gwenview.nix {};
      kate = callPackage ./kate.nix {};
      kdenlive = callPackage ./kdenlive.nix {};
      kcalc = callPackage ./kcalc.nix {};
      kcolorchooser = callPackage ./kcolorchooser.nix {};
      kcontacts = callPackage ./kcontacts.nix {};
      kdegraphics-mobipocket = callPackage ./kdegraphics-mobipocket.nix {};
      kdegraphics-thumbnailers = callPackage ./kdegraphics-thumbnailers.nix {};
      kdenetwork-filesharing = callPackage ./kdenetwork-filesharing.nix {};
      kdf = callPackage ./kdf.nix {};
      kgpg = callPackage ./kgpg.nix {};
      khelpcenter = callPackage ./khelpcenter.nix {};
      kig = callPackage ./kig.nix {};
      kio-extras = callPackage ./kio-extras.nix {};
      kmime = callPackage ./kmime.nix {};
      kmix = callPackage ./kmix.nix {};
      kompare = callPackage ./kompare.nix {};
      konsole = callPackage ./konsole.nix {};
      krfb = callPackage ./krfb.nix {};
      kwalletmanager = callPackage ./kwalletmanager.nix {};
      libkdcraw = callPackage ./libkdcraw.nix {};
      libkexiv2 = callPackage ./libkexiv2.nix {};
      libkipi = callPackage ./libkipi.nix {};
      libkomparediff2 = callPackage ./libkomparediff2.nix {};
      marble = callPackage ./marble.nix {};
      okteta = callPackage ./okteta.nix {};
      okular = callPackage ./okular.nix {};
      print-manager = callPackage ./print-manager.nix {};
      spectacle = callPackage ./spectacle.nix {};

      l10n = recurseIntoAttrs (import ./l10n.nix { inherit callPackage lib recurseIntoAttrs; });
    };

in lib.makeScope libsForQt5.newScope packages
