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
2. Run `./maintainers/scripts/fetch-kde-qt.sh pkgs/applications/kde`
   from the top of the Nixpkgs tree.
3. Use `nox-review wip` to check that everything builds.
4. Commit the changes and open a pull request.

*/

{
  stdenv, lib, libsForQt5, fetchurl, recurseIntoAttrs,
  plasma5, attica, phonon,
}:

let
  mirror = "mirror://kde";
  srcs = import ./srcs.nix { inherit fetchurl mirror; };
in

let

  packages = self: with self;
    let
      callPackage = self.newScope {
        # Team of maintainers assigned to the KDE PIM suite
        kdepimTeam = with lib.maintainers; [ ttuegel vandenoever ];

        mkDerivation = import ./build-support/application.nix {
          inherit lib;
          inherit srcs;
          mkDerivation = libsForQt5.callPackage ({ mkDerivation }: mkDerivation) {};
        };
      };
    in {
      kdelibs = callPackage ./kdelibs { inherit attica phonon; };
      akonadi = callPackage ./akonadi {};
      akonadi-contacts = callPackage ./akonadi-contacts.nix {};
      akonadi-mime = callPackage ./akonadi-mime.nix {};
      akonadi-notes = callPackage ./akonadi-notes.nix {};
      akonadi-search = callPackage ./akonadi-search.nix {};
      ark = callPackage ./ark/default.nix {};
      baloo-widgets = callPackage ./baloo-widgets.nix {};
      dolphin = callPackage ./dolphin.nix {};
      dolphin-plugins = callPackage ./dolphin-plugins.nix {};
      ffmpegthumbs = callPackage ./ffmpegthumbs.nix { };
      filelight = callPackage ./filelight.nix {};
      grantleetheme = callPackage ./grantleetheme.nix {};
      gwenview = callPackage ./gwenview.nix {};
      k3b = callPackage ./k3b.nix {};
      kate = callPackage ./kate.nix {};
      kcachegrind = callPackage ./kcachegrind.nix {};
      kcalc = callPackage ./kcalc.nix {};
      kcalcore = callPackage ./kcalcore.nix {};
      kcalutils = callPackage ./kcalutils.nix {};
      kcolorchooser = callPackage ./kcolorchooser.nix {};
      kcontacts = callPackage ./kcontacts.nix {};
      kdegraphics-mobipocket = callPackage ./kdegraphics-mobipocket.nix {};
      kdegraphics-thumbnailers = callPackage ./kdegraphics-thumbnailers.nix {};
      kdenetwork-filesharing = callPackage ./kdenetwork-filesharing.nix {};
      kdenlive = callPackage ./kdenlive.nix {};
      kdf = callPackage ./kdf.nix {};
      kgpg = callPackage ./kgpg.nix {};
      khelpcenter = callPackage ./khelpcenter.nix {};
      kidentitymanagement = callPackage ./kidentitymanagement.nix {};
      kig = callPackage ./kig.nix {};
      kimap = callPackage ./kimap.nix {};
      kio-extras = callPackage ./kio-extras.nix {};
      kldap = callPackage ./kldap.nix {};
      kmail = callPackage ./kmail.nix {};
      kmail-account-wizard = callPackage ./kmail-account-wizard.nix {};
      kmailtransport = callPackage ./kmailtransport.nix {};
      kmbox = callPackage ./kmbox.nix {};
      kmime = callPackage ./kmime.nix {};
      kmix = callPackage ./kmix.nix {};
      kolourpaint = callPackage ./kolourpaint.nix {};
      kompare = callPackage ./kompare.nix {};
      konsole = callPackage ./konsole.nix {};
      kontactinterface = callPackage ./kontactinterface.nix {};
      kpimtextedit = callPackage ./kpimtextedit.nix {};
      krfb = callPackage ./krfb.nix {};
      ktnef = callPackage ./ktnef.nix {};
      kwalletmanager = callPackage ./kwalletmanager.nix {};
      libgravatar = callPackage ./libgravatar.nix {};
      libkcddb = callPackage ./libkcddb.nix {};
      libkdcraw = callPackage ./libkdcraw.nix {};
      libkdepim = callPackage ./libkdepim.nix {};
      libkexiv2 = callPackage ./libkexiv2.nix {};
      libkipi = callPackage ./libkipi.nix {};
      libkleo = callPackage ./libkleo.nix {};
      libkomparediff2 = callPackage ./libkomparediff2.nix {};
      libksieve = callPackage ./libksieve.nix {};
      mailcommon = callPackage ./mailcommon.nix {};
      mailimporter = callPackage ./mailimporter.nix {};
      marble = callPackage ./marble.nix {};
      messagelib = callPackage ./messagelib.nix {};
      okteta = callPackage ./okteta.nix {};
      okular = callPackage ./okular.nix {};
      pimcommon = callPackage ./pimcommon.nix {};
      print-manager = callPackage ./print-manager.nix {};
      spectacle = callPackage ./spectacle.nix {};

      l10n = recurseIntoAttrs (import ./l10n.nix { inherit callPackage lib recurseIntoAttrs; });
    };

in lib.makeScope libsForQt5.newScope packages
