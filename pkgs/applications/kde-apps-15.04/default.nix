# Maintainer's Notes:
#
# Minor updates:
#  1. Edit ./manifest.sh to point to the updated URL. Upstream sometimes
#     releases updates that include only the changed packages; in this case,
#     multiple URLs can be provided and the results will be merged.
#  2. Run ./manifest.sh and ./dependencies.sh.
#  3. Build and enjoy.
#
# Major updates:
#  We prefer not to immediately overwrite older versions with major updates, so
#  make a copy of this directory first. After copying, be sure to delete ./tmp
#  if it exists. Then follow the minor update instructions.

{ pkgs, newScope, kf5 ? null, plasma5 ? null, qt5 ? null, debug ? false }:

let inherit (pkgs) autonix kde4 stdenv symlinkJoin; in

with autonix; let inherit (stdenv) lib; in

let
  kf5_ = if kf5 != null then kf5 else pkgs.kf510;
  plasma5_ = if plasma5 != null then plasma5 else pkgs.plasma53;
  qt5_ = if qt5 != null then qt5 else pkgs.qt54;
in

let

  kf5 = kf5_.override { inherit debug qt5; };
  plasma5 = plasma5_.override { inherit debug kf5 qt5; };
  qt5 = qt5_;

  kdeOrL10nPackage = name: pkg:
    assert (builtins.isAttrs pkg);
    if lib.hasPrefix "kde-l10n" pkg.name
      then l10nPackage name pkg
    else kdePackage name pkg;

  kdePackage = name: pkg:
    let defaultOverride = drv: drv // {
          setupHook = ./setup-hook.sh;
          cmakeFlags =
            (drv.cmakeFlags or [])
            ++ [ "-DBUILD_TESTING=OFF" ]
            ++ lib.optional debug "-DCMAKE_BUILD_TYPE=Debug";
          meta = {
            license = with stdenv.lib.licenses; [
              lgpl21Plus lgpl3Plus bsd2 mit gpl2Plus gpl3Plus fdl12
            ];
            platforms = stdenv.lib.platforms.linux;
            maintainers = with stdenv.lib.maintainers; [ ttuegel ];
            homepage = "http://www.kde.org";
          };
        };
        callPackage = newScope {
          inherit (stdenv) mkDerivation;
          inherit (pkgs) fetchurl;
          inherit scope;
        };
    in mkPackage callPackage defaultOverride name pkg;

  l10nPackage = name: pkg:
    let nameVersion = builtins.parseDrvName pkg.name;

        pkgQt4 = pkg // {
          name = "${nameVersion.name}-qt4-${nameVersion.version}";
          buildInputs = [ "kdelibs" "qt4" ];
          nativeBuildInputs = [ "cmake" "gettext" "perl" ];
          propagatedBuildInputs = [];
          propagatedNativeBuildInputs = [];
          propagatedUserEnvPkgs = [];
        };
        drvQt4 = overrideDerivation (kdePackage name pkgQt4) (drv: {
          preConfigure = (drv.preConfigure or "") + ''
            cd 4/
          '';
        });

        pkgQt5 = pkg // {
          name = "${nameVersion.name}-qt5-${nameVersion.version}";
          buildInputs = [ "kdoctools" "ki18n" ];
          nativeBuildInputs = [ "cmake" "extra-cmake-modules" "gettext" "perl" ];
          propagatedBuildInputs = [];
          propagatedNativeBuildInputs = [];
          propagatedUserEnvPkgs = [];
        };
        drvQt5 = overrideDerivation (kdePackage name pkgQt5) (drv: {
          preConfigure = (drv.preConfigure or "") + ''
            cd 5/
          '';
        });
    in symlinkJoin pkg.name [ drvQt4 drvQt5 ];

  super =
    let json = builtins.fromJSON (builtins.readFile ./packages.json);
        mirrorUrl = n: pkg: pkg // {
          src = pkg.src // { url = "mirror://kde/${pkg.src.url}"; };
        };
        renames =
          (builtins.fromJSON (builtins.readFile ./kf5-renames.json))
          // (builtins.fromJSON (builtins.readFile ./plasma5-renames.json))
          // (builtins.fromJSON (builtins.readFile ./renames.json));
        propagated = [ "extra-cmake-modules" ];
        native = [
          "bison"
          "extra-cmake-modules"
          "flex"
          "kdoctools"
          "ki18n"
          "libxslt"
          "perl"
          "pythoninterp"
        ];
        user = [
          "qt5"
          "qt5core"
          "qt5dbus"
          "qt5gui"
          "qt5qml"
          "qt5quick"
          "qt5svg"
          "qt5webkitwidgets"
          "qt5widgets"
          "qt5x11extras"
          "shareddesktopontologies"
          "sharedmimeinfo"
        ];
    in lib.fold (f: attrs: f attrs) json [
      (lib.mapAttrs kdeOrL10nPackage)
      (userEnvDeps user)
      (nativeDeps native)
      (propagateDeps propagated)
      (renameDeps renames)
      (lib.mapAttrs mirrorUrl)
    ];

  kde4Package = pkg: overrideScope pkg (with kde4; {
    inherit akonadi baloo kactivities libkdegames libkmahjongg;
    kde4 = self.kdelibs;
  });

  scope =
    # KDE Frameworks 5
    kf5 //
    # packages in this collection
    self //
    {
      kf5baloo = plasma5.baloo;
      kf5kdcraw = self.libkdcraw;
      kf5kdegames = self.libkdegames;
      kf5kipi = self.libkipi;
      libkonq = self.kde-baseapps;
    } //
    # packages requiring same Qt 5
    (with pkgs; {
      accountsqt5 = accounts-qt.override { inherit qt5; };
      dbusmenuqt = libdbusmenu_qt;
      grantlee5 = grantlee5.override { inherit qt5; };
      mlt = pkgs.mlt-qt5.override { inherit qt5; };
      phonon4qt5 = pkgs.phonon_qt5.override { inherit qt5; };
      qca-qt5 = qca-qt5.override { inherit qt5; };
      qt5script = qt5.script;
      qt5x11extras = qt5.x11extras;
      signonqt5 = signon.override { inherit qt5; };
      telepathyqt5 = telepathy_qt5.override { inherit qt5; };
    }) //
    # packages from nixpkgs
    (with pkgs; {
      inherit acl attr automoc4 avahi bison cdparanoia cfitsio cmake cups
              djvulibre docbook_xml_dtd_42 docbook_xsl enchant eigen2
              exiv2 fam ffmpeg flac flex freetype gmp gettext gpgme
              grantlee gsl hunspell ilmbase intltool jasper lcms2
              libaccounts-glib libgcrypt libotr libraw libssh libspectre
              libvncserver libical networkmanager openal opencv
              openexr perl phonon pkgconfig polkit_qt4 prison python qca2
              qimageblitz qjson qt4 samba saneBackends soprano speechd
              strigi taglib udev xorg xplanet xscreensaver xz pcre;
      alsa = alsaLib;
      assuan = libassuan;
      boost = boost155;
      canberra = libcanberra;
      eigen3 = eigen;
      epub = ebook_tools;
      gif = giflib;
      gphoto2 = libgphoto2;
      hupnp = herqq;
      indi = indilib;
      jpeg = libjpeg;
      ldap = openldap;
      libattica = attica;
      musicbrainz3 = libmusicbrainz;
      oggvorbis = libvorbis;
      poppler = poppler_qt4;
      pulseaudio = libpulseaudio;
      qalculate = libqalculate;
      sasl2 = cyrus_sasl;
      shareddesktopontologies = shared_desktop_ontologies;
      sharedmimeinfo = shared_mime_info;
      sndfile = libsndfile;
      tiff = libtiff;
      telepathyqt4 = telepathy_qt;
      tunepimp = libtunepimp;
      usb = libusb;
      xsltproc = libxslt;
    });

  self =
    (builtins.removeAttrs super [
      "artikulate" # build failure; wrong boost?
      "kde-dev-scripts" "kde-dev-utils" # docbook errors
      "kdewebdev" # unknown build failure
      "kde-l10n-sr" # missing CMake command
    ]) // {
      audiocd-kio = kde4Package super.audiocd-kio;

      amor = kde4Package super.amor;

      ark = extendDerivation (kde4Package super.ark) {
        buildInputs = [ pkgs.makeWrapper ];
        # runtime dependency
        postInstall = ''
          wrapProgram $out/bin/ark --prefix PATH : "${pkgs.unzipNLS}/bin"
        '';
      };

      cantor = extendDerivation (kde4Package super.cantor) {
        patches = [ ./cantor/0001-qalculate-filename-string-type.patch ];
      };

      cervisia = kde4Package super.cervisia;

      dolphin-plugins = kde4Package super.dolphin-plugins;

      dragon = kde4Package super.dragon;

      ffmpegthumbs = extendDerivation (kde4Package super.ffmpegthumbs) {
        nativeBuildInputs = [ scope.pkgconfig ];
      };

      juk = kde4Package super.juk;

      jovie = kde4Package super.jovie;

      kaccessible = kde4Package super.kaccessible;

      kaccounts-providers = extendDerivation super.kaccounts-providers {
        buildInputs = [ pkgs.libaccounts-glib ];
        # hard-coded install path
        preConfigure = ''
          substituteInPlace webkit-options/CMakeLists.txt \
            --replace "/etc/signon-ui/webkit-options.d/" \
                      "$out/etc/signon-ui/webkit-options.d/"
        '';
      };

      kajongg = kde4Package super.kajongg;

      kalzium = extendDerivation (kde4Package super.kalzium) {
        nativeBuildInputs = [ scope.pkgconfig ];
      };

      kamera = kde4Package super.kamera;

      kate = extendDerivation super.kate {
        buildInputs = with scope; [
          kconfig kguiaddons kiconthemes ki18n kinit kjobwidgets kio
          kparts ktexteditor kwindowsystem kxmlgui
        ];
        nativeBuildInputs = [ scope.kdoctools ];
      };

      kcachegrind = kde4Package super.kcachegrind;

      kcolorchooser = kde4Package super.kcolorchooser;

      kde-base-artwork = kde4Package super.kde-base-artwork;

      kde-baseapps = kde4Package super.kde-baseapps;

      kde-runtime = extendDerivation (kde4Package super.kde-runtime) {
        buildInputs = [ scope.canberra ];
        nativeBuildInputs = [ scope.pkgconfig ];
        # cmake does not detect path to `ilmbase`
        NIX_CFLAGS_COMPILE = "-I${scope.ilmbase}/include/OpenEXR";
        # some components of this package have been replaced in other packages
        meta = { priority = 10; };
      };

      kde-wallpapers = kde4Package super.kde-wallpapers;

      kde-workspace = extendDerivation (kde4Package super.kde-workspace) {
        patches = [ ./kde-workspace/ksysguard-0001-disable-signalplottertest.patch ];
        buildInputs = with scope.xorg; [
            libxkbfile libXcomposite xcbutilimage xcbutilkeysyms xcbutilrenderutil
        ];
        nativeBuildInputs = [ scope.pkgconfig ];
        # some components of this package have been replaced in other packages
        meta = { priority = 10; };
      };

      kdeartwork = kde4Package super.kdeartwork;

      kdegraphics-mobipocket = kde4Package super.kdegraphics-mobipocket;

      kdegraphics-strigi-analyzer = kde4Package super.kdegraphics-strigi-analyzer;

      kdegraphics-thumbnailers = kde4Package super.kdegraphics-thumbnailers;

      kdelibs = extendDerivation super.kdelibs {
        buildInputs = with scope; [ attr polkit_qt4 xsltproc xz pcre ];
        propagatedBuildInputs = with scope; [ qt4 soprano phonon strigi ];
        nativeBuildInputs = [ scope.pkgconfig ];
        propagatedNativeBuildInputs = with scope; [
          automoc4 cmake perl sharedmimeinfo
        ];

        patches = [ ./kdelibs/polkit-install.patch ];

        # cmake does not detect path to `ilmbase`
        NIX_CFLAGS_COMPILE = "-I${scope.ilmbase}/include/OpenEXR";

        cmakeFlags = [
          "-DDOCBOOKXML_CURRENTDTD_DIR=${scope.docbook_xml_dtd_42}/xml/dtd/docbook"
          "-DDOCBOOKXSL_DIR=${scope.docbook_xsl}/xml/xsl/docbook"
          "-DHUPNP_ENABLED=ON"
          "-DWITH_SOLID_UDISKS2=ON"
          "-DKDE_DEFAULT_HOME=.kde"
        ];
      };

      kdenetwork-filesharing = kde4Package super.kdenetwork-filesharing;

      kdenetwork-strigi-analyzers = kde4Package super.kdenetwork-strigi-analyzers;

      kdenlive = extendDerivation super.kdenlive { buildInputs = [ scope.mlt ]; };

      kdepim = extendDerivation (kde4Package super.kdepim) {
        buildInputs = with scope; [ gpgme assuan ];
        nativeBuildInputs = [ scope.pkgconfig ];
      };

      kdepim-runtime = kde4Package super.kdepim-runtime;

      kdepimlibs = extendDerivation (kde4Package super.kdepimlibs) {
        nativeBuildInputs = [ scope.pkgconfig ];
      };

      kdesdk-kioslaves = kde4Package super.kdesdk-kioslaves;

      kdesdk-strigi-analyzers = kde4Package super.kdesdk-strigi-analyzers;

      kdesdk-thumbnailers =
        extendDerivation (kde4Package super.kdesdk-thumbnailers) {
          nativeBuildInputs = [ scope.gettext ];
        };

      kdf = kde4Package super.kdf;

      kfloppy = kde4Package super.kfloppy;

      kgamma = kde4Package super.kgamma;

      kget = kde4Package super.kget;

      kgoldrunner = kde4Package super.kgoldrunner;

      kgpg = extendDerivation (kde4Package super.kgpg) {
        buildInputs = [ scope.boost ];
      };

      khangman = extendDerivation super.khangman { buildInputs = [ scope.kio ]; };

      kigo = kde4Package super.kigo;

      kiriki = kde4Package super.kiriki;

      klickety = kde4Package super.klickety;

      kmag = kde4Package super.kmag;

      kmahjongg = kde4Package super.kmahjongg;

      kmix = extendDerivation super.kmix {
        nativeBuildInputs = [ scope.pkgconfig ];
        cmakeFlags = [ "-DKMIX_KF5_BUILD=ON" ];
      };

      kmousetool = extendDerivation (kde4Package super.kmousetool) {
        buildInputs = with scope.xorg; [ libXtst libXt ];
      };

      kmouth = kde4Package super.kmouth;

      knavalbattle = kde4Package super.knavalbattle;

      kolf = kde4Package super.kolf;

      kolourpaint = kde4Package super.kolourpaint;

      konquest = kde4Package super.konquest;

      kopete = kde4Package super.kopete;

      kppp = kde4Package super.kppp;

      kqtquickcharts = kde4Package super.kqtquickcharts;

      krdc = kde4Package super.krdc;

      kremotecontrol = extendDerivation (kde4Package super.kremotecontrol) {
        buildInputs = [ scope.xorg.libXtst ];
      };

      kreversi = kde4Package super.kreversi;

      krfb = extendDerivation (kde4Package super.krfb) {
        buildInputs = with scope; [ xorg.libXtst ktp-common-internals ];
      };

      ksaneplugin = kde4Package super.ksaneplugin;

      kscd = kde4Package super.kscd;

      ksirk = kde4Package super.ksirk;

      ksnakeduel = kde4Package super.ksnakeduel;

      ksnapshot = kde4Package super.ksnapshot;

      kspaceduel = kde4Package super.kspaceduel;

      kstars = extendDerivation super.kstars {
        buildInputs = with scope; [ kparts cfitsio ];
      };

      ksudoku = kde4Package super.ksudoku;

      ksystemlog = kde4Package super.ksystemlog;

      ktp-accounts-kcm = extendDerivation super.ktp-accounts-kcm {
        buildInputs = [ scope.libaccounts-glib ];
      };

      ktp-common-internals = extendDerivation super.ktp-common-internals {
        buildInputs = with scope; [ kdelibs4support kparts libotr ];
      };

      ktp-text-ui = extendDerivation super.ktp-text-ui {
        buildInputs = [ scope.kdbusaddons ];
      };

      ktuberling = kde4Package super.ktuberling;

      ktux = kde4Package super.ktux;

      kubrick = kde4Package super.kubrick;

      kuser = kde4Package super.kuser;

      kwalletmanager = kde4Package super.kwalletmanager;

      lokalize = extendDerivation super.lokalize {
        buildInputs = [ scope.kdbusaddons ];
      };

      libkcddb = kde4Package super.libkcddb;

      libkcompactdisc = kde4Package super.libkcompactdisc;

      libkdcraw = extendDerivation super.libkdcraw {
        buildInputs = with scope; [ kdelibs libraw ];
        nativeBuildInputs = [ scope.pkgconfig ];
      };

      libkdeedu = kde4Package super.libkdeedu;

      libkexiv2 = extendDerivation super.libkexiv2 {
        buildInputs = with scope; [ exiv2 kdelibs ];
      };

      libkface = extendDerivation super.libkface {
        buildInputs = with scope; [ kdelibs opencv ];
      };

      libkgeomap = extendDerivation (kde4Package super.libkgeomap) {
        cmakeFlags =
          [ "-DCMAKE_MODULE_PATH=${scope.marble}/share/apps/cmake/modules" ];
      };

      libkipi = extendDerivation super.libkipi {
        buildInputs = [ scope.kdelibs ];
      };

      libksane = extendDerivation super.libksane {
        buildInputs = with scope; [ kdelibs saneBackends];
      };

      lskat = kde4Package super.lskat;

      marble = kde4Package super.marble;

      mplayerthumbs = kde4Package super.mplayerthumbs;

      okular = extendDerivation (kde4Package super.okular) {
        nativeBuildInputs = [ scope.pkgconfig ];
      };

      pairs = kde4Package super.pairs;

      palapeli = kde4Package super.palapeli;

      picmi = kde4Package super.picmi;

      poxml = kde4Package super.poxml;

      rocs = extendDerivation super.rocs {
        buildInputs = [ scope.kdelibs4support ];
      };

      signon-kwallet-extension = extendDerivation super.signon-kwallet-extension {
        buildInputs = [ scope.signonqt5 ];
        preConfigure = ''
          sed -i src/CMakeLists.txt \
              -e "s,\''${SIGNONEXTENSION_PLUGINDIR},$out/lib/signon/extensions,"
        '';
      };

      superkaramba = kde4Package super.superkaramba;

      svgpart = kde4Package super.svgpart;

      sweeper = kde4Package super.sweeper;

      umbrello = kde4Package super.umbrello;

      zeroconf-ioslave = kde4Package super.zeroconf-ioslave;

    };

in self
