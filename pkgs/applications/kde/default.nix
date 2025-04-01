/*
  # New packages

  READ THIS FIRST

  This module is for official packages in the KDE Gear. All available
  packages are listed in `./srcs.nix`, although some are not yet
  packaged in Nixpkgs (see below).

  IF YOUR PACKAGE IS NOT LISTED IN `./srcs.nix`, IT DOES NOT GO HERE.

  Many of the packages released upstream are not yet built in Nixpkgs due to lack
  of demand. To add a Nixpkgs build for an upstream package, copy one of the
  existing packages here and modify it as necessary. A simple example package that
  still shows most of the available features is in `./gwenview`.

  # Updates

  1. Update the URL in `./fetch.sh`.
  2. Run `./maintainers/scripts/fetch-kde-qt.sh pkgs/applications/kde`
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
            homepage = meta.homepage or "http://www.kde.org";
            platforms = meta.platforms or lib.platforms.linux;
          };
      }
    );

  packages =
    self:
    with self;
    let
      callPackage = self.newScope {
        inherit mkDerivation;

        # Team of maintainers assigned to the KDE PIM suite
        kdepimTeam = with lib.maintainers; [
          ttuegel
          vandenoever
          nyanloutre
        ];
      };
    in
    {
      akonadi = callPackage ./akonadi { };
      akonadi-calendar = callPackage ./akonadi-calendar.nix { };
      akonadi-calendar-tools = callPackage ./akonadi-calendar-tools.nix { };
      akonadi-contacts = callPackage ./akonadi-contacts.nix { };
      akonadi-import-wizard = callPackage ./akonadi-import-wizard.nix { };
      akonadi-mime = callPackage ./akonadi-mime.nix { };
      akonadi-notes = callPackage ./akonadi-notes.nix { };
      akonadi-search = callPackage ./akonadi-search.nix { };
      akonadiconsole = callPackage ./akonadiconsole.nix { };
      akregator = callPackage ./akregator.nix { };
      analitza = callPackage ./analitza.nix { };
      arianna = callPackage ./arianna.nix { };
      ark = callPackage ./ark { };
      baloo-widgets = callPackage ./baloo-widgets.nix { };
      bomber = callPackage ./bomber.nix { };
      bovo = callPackage ./bovo.nix { };
      calendarsupport = callPackage ./calendarsupport.nix { };
      colord-kde = callPackage ./colord-kde.nix { };
      cantor = callPackage ./cantor.nix { };
      dolphin = callPackage ./dolphin.nix { };
      dolphin-plugins = callPackage ./dolphin-plugins.nix { };
      dragon = callPackage ./dragon.nix { };
      elisa = callPackage ./elisa.nix { };
      eventviews = callPackage ./eventviews.nix { };
      falkon = callPackage ./falkon.nix { };
      ffmpegthumbs = callPackage ./ffmpegthumbs.nix { };
      filelight = callPackage ./filelight.nix { };
      ghostwriter = callPackage ./ghostwriter.nix { };
      granatier = callPackage ./granatier.nix { };
      grantleetheme = callPackage ./grantleetheme { };
      gwenview = callPackage ./gwenview { };
      incidenceeditor = callPackage ./incidenceeditor.nix { };
      itinerary = callPackage ./itinerary.nix { };
      juk = callPackage ./juk.nix { };
      k3b = callPackage ./k3b.nix { };
      kaccounts-integration = callPackage ./kaccounts-integration.nix { };
      kaccounts-providers = callPackage ./kaccounts-providers.nix { };
      kaddressbook = callPackage ./kaddressbook.nix { };
      kalarm = callPackage ./kalarm.nix { };
      kalgebra = callPackage ./kalgebra.nix { };
      merkuro = callPackage ./merkuro.nix { };
      kalzium = callPackage ./kalzium.nix { };
      kamoso = callPackage ./kamoso.nix { };
      kapman = callPackage ./kapman.nix { };
      kapptemplate = callPackage ./kapptemplate.nix { };
      kate = callPackage ./kate.nix { };
      katomic = callPackage ./katomic.nix { };
      kblackbox = callPackage ./kblackbox.nix { };
      kblocks = callPackage ./kblocks.nix { };
      kbounce = callPackage ./kbounce.nix { };
      kbreakout = callPackage ./kbreakout.nix { };
      kcachegrind = callPackage ./kcachegrind.nix { };
      kcalc = callPackage ./kcalc.nix { };
      kcalutils = callPackage ./kcalutils.nix { };
      kcharselect = callPackage ./kcharselect.nix { };
      kcolorchooser = callPackage ./kcolorchooser.nix { };
      kde-inotify-survey = callPackage ./kde-inotify-survey.nix { };
      kdebugsettings = callPackage ./kdebugsettings.nix { };
      kdeconnect-kde = callPackage ./kdeconnect-kde.nix { };
      kdegraphics-mobipocket = callPackage ./kdegraphics-mobipocket.nix { };
      kdegraphics-thumbnailers = callPackage ./kdegraphics-thumbnailers { };
      kdenetwork-filesharing = callPackage ./kdenetwork-filesharing.nix { };
      kdenlive = callPackage ./kdenlive { };
      kdepim-addons = callPackage ./kdepim-addons.nix { };
      kdepim-runtime = callPackage ./kdepim-runtime { };
      kdev-php = callPackage ./kdevelop/kdev-php.nix { };
      kdev-python = callPackage ./kdevelop/kdev-python.nix { };
      kdevelop = callPackage ./kdevelop/wrapper.nix { };
      kdevelop-pg-qt = callPackage ./kdevelop/kdevelop-pg-qt.nix { };
      kdevelop-unwrapped = callPackage ./kdevelop/kdevelop.nix { };
      kdf = callPackage ./kdf.nix { };
      kdialog = callPackage ./kdialog.nix { };
      kdiamond = callPackage ./kdiamond.nix { };
      keditbookmarks = callPackage ./keditbookmarks.nix { };
      kfind = callPackage ./kfind.nix { };
      kgeography = callPackage ./kgeography.nix { };
      kget = callPackage ./kget.nix { };
      kgpg = callPackage ./kgpg.nix { };
      khelpcenter = callPackage ./khelpcenter.nix { };
      kidentitymanagement = callPackage ./kidentitymanagement.nix { };
      kig = callPackage ./kig.nix { };
      kigo = callPackage ./kigo.nix { };
      killbots = callPackage ./killbots.nix { };
      kimap = callPackage ./kimap.nix { };
      kio-admin = callPackage ./kio-admin.nix { };
      kio-extras = callPackage ./kio-extras.nix { };
      kio-gdrive = callPackage ./kio-gdrive.nix { };
      kipi-plugins = callPackage ./kipi-plugins.nix { };
      kirigami-gallery = callPackage ./kirigami-gallery.nix { };
      kitinerary = callPackage ./kitinerary.nix { };
      kldap = callPackage ./kldap.nix { };
      kleopatra = callPackage ./kleopatra.nix { };
      klettres = callPackage ./klettres.nix { };
      klines = callPackage ./klines.nix { };
      kmag = callPackage ./kmag.nix { };
      kmahjongg = callPackage ./kmahjongg.nix { };
      kmail = callPackage ./kmail.nix { };
      kmail-account-wizard = callPackage ./kmail-account-wizard.nix { };
      kmailtransport = callPackage ./kmailtransport.nix { };
      kmbox = callPackage ./kmbox.nix { };
      kmime = callPackage ./kmime.nix { };
      kmines = callPackage ./kmines.nix { };
      kmix = callPackage ./kmix.nix { };
      kmousetool = callPackage ./kmousetool.nix { };
      kmplot = callPackage ./kmplot.nix { };
      knavalbattle = callPackage ./knavalbattle.nix { };
      knetwalk = callPackage ./knetwalk.nix { };
      knights = callPackage ./knights.nix { };
      knotes = callPackage ./knotes.nix { };
      kolf = callPackage ./kolf.nix { };
      kollision = callPackage ./kollision.nix { };
      kolourpaint = callPackage ./kolourpaint.nix { };
      kompare = callPackage ./kompare.nix { };
      konqueror = callPackage ./konqueror.nix { };
      konquest = callPackage ./konquest.nix { };
      konsole = callPackage ./konsole.nix { };
      kontact = callPackage ./kontact.nix { };
      konversation = callPackage ./konversation.nix { };
      kontactinterface = callPackage ./kontactinterface.nix { };
      kopeninghours = callPackage ./kopeninghours.nix { };
      korganizer = callPackage ./korganizer.nix { };
      kosmindoormap = callPackage ./kosmindoormap.nix { };
      kpat = callPackage ./kpat.nix { };
      kpimtextedit = callPackage ./kpimtextedit.nix { };
      kpkpass = callPackage ./kpkpass.nix { };
      kpmcore = callPackage ./kpmcore { };
      kpublictransport = callPackage ./kpublictransport.nix { };
      kqtquickcharts = callPackage ./kqtquickcharts.nix { };
      krdc = callPackage ./krdc.nix { };
      kreversi = callPackage ./kreversi.nix { };
      krfb = callPackage ./krfb.nix { };
      kruler = callPackage ./kruler.nix { };
      ksanecore = callPackage ./ksanecore.nix { };
      kshisen = callPackage ./kshisen.nix { };
      ksmtp = callPackage ./ksmtp { };
      kspaceduel = callPackage ./kspaceduel.nix { };
      ksquares = callPackage ./ksquares.nix { };
      ksudoku = callPackage ./ksudoku.nix { };
      ksystemlog = callPackage ./ksystemlog.nix { };
      kteatime = callPackage ./kteatime.nix { };
      ktimer = callPackage ./ktimer.nix { };
      ktnef = callPackage ./ktnef.nix { };
      ktorrent = callPackage ./ktorrent.nix { };
      ktouch = callPackage ./ktouch.nix { };
      kturtle = callPackage ./kturtle.nix { };
      kwalletmanager = callPackage ./kwalletmanager.nix { };
      kwave = callPackage ./kwave.nix { };
      libgravatar = callPackage ./libgravatar.nix { };
      libkcddb = callPackage ./libkcddb.nix { };
      libkdcraw = callPackage ./libkdcraw.nix { };
      libkdegames = callPackage ./libkdegames.nix { };
      libkdepim = callPackage ./libkdepim.nix { };
      libkexiv2 = callPackage ./libkexiv2.nix { };
      libkgapi = callPackage ./libkgapi.nix { };
      libkipi = callPackage ./libkipi.nix { };
      libkleo = callPackage ./libkleo.nix { };
      libkmahjongg = callPackage ./libkmahjongg.nix { };
      libkomparediff2 = callPackage ./libkomparediff2.nix { };
      libksane = callPackage ./libksane.nix { };
      libksieve = callPackage ./libksieve.nix { };
      libktorrent = callPackage ./libktorrent.nix { };
      mailcommon = callPackage ./mailcommon.nix { };
      mailimporter = callPackage ./mailimporter.nix { };
      marble = callPackage ./marble.nix { };
      mbox-importer = callPackage ./mbox-importer.nix { };
      messagelib = callPackage ./messagelib.nix { };
      minuet = callPackage ./minuet.nix { };
      okular = callPackage ./okular.nix { };
      palapeli = callPackage ./palapeli.nix { };
      partitionmanager = callPackage ./partitionmanager { };
      picmi = callPackage ./picmi.nix { };
      pim-data-exporter = callPackage ./pim-data-exporter.nix { };
      pim-sieve-editor = callPackage ./pim-sieve-editor.nix { };
      pimcommon = callPackage ./pimcommon.nix { };
      print-manager = callPackage ./print-manager.nix { };
      rocs = callPackage ./rocs.nix { };
      skanlite = callPackage ./skanlite.nix { };
      skanpage = callPackage ./skanpage.nix { };
      spectacle = callPackage ./spectacle.nix { };
      umbrello = callPackage ./umbrello.nix { };
      yakuake = callPackage ./yakuake.nix { };
      zanshin = callPackage ./zanshin.nix { };

      # Plasma Mobile Gear
      alligator = callPackage ./alligator.nix { };
      angelfish = callPackage ./angelfish.nix { inherit srcs; };
      audiotube = callPackage ./audiotube.nix { };
      calindori = callPackage ./calindori.nix { };
      kalk = callPackage ./kalk.nix { };
      kasts = callPackage ./kasts.nix { };
      kclock = callPackage ./kclock.nix { };
      keysmith = callPackage ./keysmith.nix { };
      koko = callPackage ./koko.nix { };
      kongress = callPackage ./kongress.nix { };
      krecorder = callPackage ./krecorder.nix { };
      ktrip = callPackage ./ktrip.nix { };
      kweather = callPackage ./kweather.nix { };
      neochat = callPackage ./neochat.nix { };
      plasmatube = callPackage ./plasmatube { };
      qmlkonsole = callPackage ./qmlkonsole.nix { };
      telly-skout = callPackage ./telly-skout.nix { };
      tokodon = callPackage ./tokodon.nix { };
    };

in
lib.makeScope libsForQt5.newScope packages
