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
  lib, libsForQt5, fetchurl,
  okteta
}:

let
  mirror = "mirror://kde";
  srcs = import ./srcs.nix { inherit fetchurl mirror; };

  mkDerivation = args:
    let
      inherit (args) name;
      sname = args.sname or name;
      inherit (srcs."${sname}") src version;
      mkDerivation =
        libsForQt5.callPackage ({ mkDerivation }: mkDerivation) {};
    in
      mkDerivation (args // {
        name = "${name}-${version}";
        inherit src;

        outputs = args.outputs or [ "out" ];

        meta = {
          platforms = lib.platforms.linux;
          homepage = "http://www.kde.org";
        } // (args.meta or {});
      });

  packages = self: with self;
    let
      callPackage = self.newScope {
        inherit mkDerivation;

        # Team of maintainers assigned to the KDE PIM suite
        kdepimTeam = with lib.maintainers; [ ttuegel vandenoever ];
      };
    in {
      akonadi = callPackage ./akonadi {};
      akonadi-calendar = callPackage ./akonadi-calendar.nix {};
      akonadi-contacts = callPackage ./akonadi-contacts.nix {};
      akonadi-import-wizard = callPackage ./akonadi-import-wizard.nix {};
      akonadi-mime = callPackage ./akonadi-mime.nix {};
      akonadi-notes = callPackage ./akonadi-notes.nix {};
      akonadi-search = callPackage ./akonadi-search.nix {};
      akonadiconsole = callPackage ./akonadiconsole.nix {};
      akregator = callPackage ./akregator.nix {};
      ark = callPackage ./ark {};
      baloo-widgets = callPackage ./baloo-widgets.nix {};
      calendarsupport = callPackage ./calendarsupport.nix {};
      dolphin = callPackage ./dolphin.nix {};
      dolphin-plugins = callPackage ./dolphin-plugins.nix {};
      dragon = callPackage ./dragon.nix {};
      eventviews = callPackage ./eventviews.nix {};
      ffmpegthumbs = callPackage ./ffmpegthumbs.nix { };
      filelight = callPackage ./filelight.nix {};
      grantleetheme = callPackage ./grantleetheme {};
      gwenview = callPackage ./gwenview.nix {};
      incidenceeditor = callPackage ./incidenceeditor.nix {};
      k3b = callPackage ./k3b.nix {};
      kaddressbook = callPackage ./kaddressbook.nix {};
      kalarm = callPackage ./kalarm.nix {};
      kalarmcal = callPackage ./kalarmcal.nix {};
      kate = callPackage ./kate.nix {};
      kcachegrind = callPackage ./kcachegrind.nix {};
      kcalc = callPackage ./kcalc.nix {};
      kcalcore = callPackage ./kcalcore.nix {};
      kcalutils = callPackage ./kcalutils.nix {};
      kcolorchooser = callPackage ./kcolorchooser.nix {};
      kcontacts = callPackage ./kcontacts.nix {};
      kdav = callPackage ./kdav.nix {};
      kdebugsettings = callPackage ./kdebugsettings.nix {};
      kdegraphics-mobipocket = callPackage ./kdegraphics-mobipocket.nix {};
      kdegraphics-thumbnailers = callPackage ./kdegraphics-thumbnailers.nix {};
      kdenetwork-filesharing = callPackage ./kdenetwork-filesharing.nix {};
      kdenlive = callPackage ./kdenlive.nix {};
      kdepim-runtime = callPackage ./kdepim-runtime.nix {};
      kdepim-addons = callPackage ./kdepim-addons.nix {};
      kdepim-apps-libs = callPackage ./kdepim-apps-libs {};
      kdf = callPackage ./kdf.nix {};
      kdialog = callPackage ./kdialog.nix {};
      keditbookmarks = callPackage ./keditbookmarks.nix {};
      kget = callPackage ./kget.nix {};
      kgpg = callPackage ./kgpg.nix {};
      khelpcenter = callPackage ./khelpcenter.nix {};
      kidentitymanagement = callPackage ./kidentitymanagement.nix {};
      kig = callPackage ./kig.nix {};
      kimap = callPackage ./kimap.nix {};
      kitinerary = callPackage ./kitinerary.nix {};
      kio-extras = callPackage ./kio-extras.nix {};
      kldap = callPackage ./kldap.nix {};
      kleopatra = callPackage ./kleopatra.nix {};
      kmail = callPackage ./kmail.nix {};
      kmail-account-wizard = callPackage ./kmail-account-wizard.nix {};
      kmailtransport = callPackage ./kmailtransport.nix {};
      kmbox = callPackage ./kmbox.nix {};
      kmime = callPackage ./kmime.nix {};
      kmix = callPackage ./kmix.nix {};
      kolourpaint = callPackage ./kolourpaint.nix {};
      kompare = callPackage ./kompare.nix {};
      konsole = callPackage ./konsole.nix {};
      kontact = callPackage ./kontact.nix {};
      kontactinterface = callPackage ./kontactinterface.nix {};
      konquest = callPackage ./konquest.nix {};
      korganizer = callPackage ./korganizer.nix {};
      kpimtextedit = callPackage ./kpimtextedit.nix {};
      ksmtp = callPackage ./ksmtp {};
      kqtquickcharts = callPackage ./kqtquickcharts.nix {};
      kpkpass = callPackage ./kpkpass.nix {};
      krdc = callPackage ./krdc.nix {};
      krfb = callPackage ./krfb.nix {};
      kruler = callPackage ./kruler.nix {};
      ksystemlog = callPackage ./ksystemlog.nix {};
      ktnef = callPackage ./ktnef.nix {};
      kwalletmanager = callPackage ./kwalletmanager.nix {};
      libgravatar = callPackage ./libgravatar.nix {};
      libkcddb = callPackage ./libkcddb.nix {};
      libkdcraw = callPackage ./libkdcraw.nix {};
      libkdegames = callPackage ./libkdegames.nix {};
      libkdepim = callPackage ./libkdepim.nix {};
      libkexiv2 = callPackage ./libkexiv2.nix {};
      libkgapi = callPackage ./libkgapi.nix {};
      libkipi = callPackage ./libkipi.nix {};
      libkleo = callPackage ./libkleo.nix {};
      libkomparediff2 = callPackage ./libkomparediff2.nix {};
      libksane = callPackage ./libksane.nix {};
      libksieve = callPackage ./libksieve.nix {};
      mailcommon = callPackage ./mailcommon.nix {};
      mailimporter = callPackage ./mailimporter.nix {};
      marble = callPackage ./marble.nix {};
      mbox-importer = callPackage ./mbox-importer.nix {};
      messagelib = callPackage ./messagelib.nix {};
      minuet = callPackage ./minuet.nix {};
      okular = callPackage ./okular.nix {};
      pimcommon = callPackage ./pimcommon.nix {};
      pim-data-exporter = callPackage ./pim-data-exporter.nix {};
      pim-sieve-editor = callPackage ./pim-sieve-editor.nix {};
      print-manager = callPackage ./print-manager.nix {};
      spectacle = callPackage ./spectacle.nix {};
      syndication = callPackage ./syndication.nix {};
      # Okteta was removed from kde applications and will now be released independently
      # Lets keep an alias for compatibility reasons
      inherit okteta;
    };

in lib.makeScope libsForQt5.newScope packages
