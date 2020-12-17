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
}:

let
  mirror = "mirror://kde";
  srcs = import ./srcs.nix { inherit fetchurl mirror; };

  mkDerivation = args:
    let
      inherit (args) name;
      sname = args.sname or name;
      inherit (srcs.${sname}) src version;
      mkDerivation =
        libsForQt5.callPackage ({ mkDerivation }: mkDerivation) {};
    in
      mkDerivation (args // {
        pname = name;
        inherit src version;

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
        kdepimTeam = with lib.maintainers; [ ttuegel vandenoever nyanloutre ];
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
      bovo = callPackage ./bovo.nix {};
      bomber = callPackage ./bomber.nix {};
      calendarsupport = callPackage ./calendarsupport.nix {};
      dolphin = callPackage ./dolphin.nix {};
      dolphin-plugins = callPackage ./dolphin-plugins.nix {};
      dragon = callPackage ./dragon.nix {};
      elisa = callPackage ./elisa.nix {};
      eventviews = callPackage ./eventviews.nix {};
      ffmpegthumbs = callPackage ./ffmpegthumbs.nix { };
      filelight = callPackage ./filelight.nix {};
      granatier = callPackage ./granatier.nix {};
      grantleetheme = callPackage ./grantleetheme {};
      gwenview = callPackage ./gwenview.nix {};
      incidenceeditor = callPackage ./incidenceeditor.nix {};
      k3b = callPackage ./k3b.nix {};
      kaddressbook = callPackage ./kaddressbook.nix {};
      kalarm = callPackage ./kalarm.nix {};
      kalarmcal = callPackage ./kalarmcal.nix {};
      kalzium = callPackage ./kalzium.nix {};
      kapman = callPackage ./kapman.nix {};
      kapptemplate = callPackage ./kapptemplate.nix { };
      kate = callPackage ./kate.nix {};
      katomic = callPackage ./katomic.nix {};
      kblackbox = callPackage ./kblackbox.nix {};
      kblocks = callPackage ./kblocks.nix {};
      kbounce = callPackage ./kbounce.nix {};
      kbreakout = callPackage ./kbreakout.nix {};
      kcachegrind = callPackage ./kcachegrind.nix {};
      kcalc = callPackage ./kcalc.nix {};
      kcalutils = callPackage ./kcalutils.nix {};
      kcharselect = callPackage ./kcharselect.nix {};
      kcolorchooser = callPackage ./kcolorchooser.nix {};
      kdebugsettings = callPackage ./kdebugsettings.nix {};
      kdeconnect-kde = callPackage ./kdeconnect-kde.nix {};
      kdegraphics-mobipocket = callPackage ./kdegraphics-mobipocket.nix {};
      kdegraphics-thumbnailers = callPackage ./kdegraphics-thumbnailers.nix {};
      kdenetwork-filesharing = callPackage ./kdenetwork-filesharing.nix {};
      kdenlive = callPackage ./kdenlive.nix {};
      kdepim-runtime = callPackage ./kdepim-runtime {};
      kdepim-addons = callPackage ./kdepim-addons.nix {};
      kdepim-apps-libs = callPackage ./kdepim-apps-libs {};
      kdf = callPackage ./kdf.nix {};
      kdialog = callPackage ./kdialog.nix {};
      kdiamond = callPackage ./kdiamond.nix {};
      keditbookmarks = callPackage ./keditbookmarks.nix {};
      kfind = callPackage ./kfind.nix {};
      kfloppy = callPackage ./kfloppy.nix {};
      kgeography = callPackage ./kgeography.nix {};
      kget = callPackage ./kget.nix {};
      kgpg = callPackage ./kgpg.nix {};
      khelpcenter = callPackage ./khelpcenter.nix {};
      kidentitymanagement = callPackage ./kidentitymanagement.nix {};
      kig = callPackage ./kig.nix {};
      kigo = callPackage ./kigo.nix {};
      killbots = callPackage ./killbots.nix {};
      kimap = callPackage ./kimap.nix {};
      kipi-plugins = callPackage ./kipi-plugins.nix {};
      kitinerary = callPackage ./kitinerary.nix {};
      kio-extras = callPackage ./kio-extras.nix {};
      kldap = callPackage ./kldap.nix {};
      kleopatra = callPackage ./kleopatra.nix {};
      klettres = callPackage ./klettres.nix {};
      klines = callPackage ./klines.nix {};
      kmag = callPackage ./kmag.nix {};
      kmahjongg = callPackage ./kmahjongg.nix {};
      kmail = callPackage ./kmail.nix {};
      kmail-account-wizard = callPackage ./kmail-account-wizard.nix {};
      kmailtransport = callPackage ./kmailtransport.nix {};
      kmbox = callPackage ./kmbox.nix {};
      kmime = callPackage ./kmime.nix {};
      kmines = callPackage ./kmines.nix {};
      kmix = callPackage ./kmix.nix {};
      kmplot = callPackage ./kmplot.nix {};
      knavalbattle = callPackage ./knavalbattle.nix {};
      knetwalk = callPackage ./knetwalk.nix {};
      knights = callPackage ./knights.nix {};
      knotes = callPackage ./knotes.nix {};
      kolf = callPackage ./kolf.nix {};
      kollision = callPackage ./kollision.nix {};
      kolourpaint = callPackage ./kolourpaint.nix {};
      kompare = callPackage ./kompare.nix {};
      konsole = callPackage ./konsole.nix {};
      kontact = callPackage ./kontact.nix {};
      kontactinterface = callPackage ./kontactinterface.nix {};
      konquest = callPackage ./konquest.nix {};
      konqueror = callPackage ./konqueror.nix {};
      korganizer = callPackage ./korganizer.nix {};
      kpat = callPackage ./kpat.nix {};
      kpimtextedit = callPackage ./kpimtextedit.nix {};
      ksmtp = callPackage ./ksmtp {};
      ksquares = callPackage ./ksquares.nix {};
      kqtquickcharts = callPackage ./kqtquickcharts.nix {};
      kpkpass = callPackage ./kpkpass.nix {};
      kreversi = callPackage ./kreversi.nix {};
      krdc = callPackage ./krdc.nix {};
      krfb = callPackage ./krfb.nix {};
      kruler = callPackage ./kruler.nix {};
      kshisen = callPackage ./kshisen.nix {};
      kspaceduel = callPackage ./kspaceduel.nix {};
      ksudoku = callPackage ./ksudoku.nix {};
      ksystemlog = callPackage ./ksystemlog.nix {};
      kteatime = callPackage ./kteatime.nix {};
      ktimer = callPackage ./ktimer.nix {};
      ktnef = callPackage ./ktnef.nix {};
      ktouch = callPackage ./ktouch.nix {};
      kturtle = callPackage ./kturtle.nix {};
      kwalletmanager = callPackage ./kwalletmanager.nix {};
      kwave = callPackage ./kwave.nix {};
      libgravatar = callPackage ./libgravatar.nix {};
      libkcddb = callPackage ./libkcddb.nix {};
      libkdcraw = callPackage ./libkdcraw.nix {};
      libkdegames = callPackage ./libkdegames.nix {};
      libkdepim = callPackage ./libkdepim.nix {};
      libkexiv2 = callPackage ./libkexiv2.nix {};
      libkgapi = callPackage ./libkgapi.nix {};
      libkipi = callPackage ./libkipi.nix {};
      libkleo = callPackage ./libkleo.nix {};
      libkmahjongg = callPackage ./libkmahjongg.nix {};
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
      picmi = callPackage ./picmi.nix {};
      pimcommon = callPackage ./pimcommon.nix {};
      pim-data-exporter = callPackage ./pim-data-exporter.nix {};
      pim-sieve-editor = callPackage ./pim-sieve-editor.nix {};
      print-manager = callPackage ./print-manager.nix {};
      rocs = callPackage ./rocs.nix {};
      spectacle = callPackage ./spectacle.nix {};
      yakuake = callPackage ./yakuake.nix {};
    };

in lib.makeScope libsForQt5.newScope packages
