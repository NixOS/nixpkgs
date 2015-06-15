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

{ autonix, symlinkJoin, kde4, kf5, pkgs, qt4, qt5, stdenv, newScope, debug ? false }:

with autonix;

let inherit (stdenv) lib; in

let kf5Orig = kf5; in

let

  kf5 = kf5Orig.override { inherit debug qt5; };

  kdePackage = pkg:
    (kf5.kdePackage pkg).override {
      inherit (stdenv) mkDerivation;
      inherit scope;
    };

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

  overrideDerivation = pkg: f:
    let mkDerivation = super: drv: super.mkDerivation (drv // f drv);
    in pkg.override (super: super // { mkDerivation = mkDerivation super; });

  scope =
    # packages in this collection
    self //
    {
      kf5kdegames = self.libkdegames;
      libkonq = self.kde-baseapps;
    } //
    # packages from KDE Frameworks 5
    kf5.scope //
    # packages requiring same Qt 5
    (with pkgs; {
      accountsqt5 = accounts-qt.override { inherit qt5; };
      dbusmenuqt = libdbusmenu_qt;
      grantlee5 = grantlee5.override { inherit qt5; };
      mlt = pkgs.mlt-qt5.override { inherit qt5; };
      qca-qt5 = qca-qt5.override { inherit qt5; };
      signonqt5 = signon.override { inherit qt5; };
      telepathyqt5 = telepathy_qt5.override { inherit qt5; };
    }) //
    # packages from KDE 4
    (with kde4; {
      inherit akonadi baloo kactivities libkdegames libkmahjongg;
      kde4 = self.kdelibs;
    }) //
    # packages from nixpkgs
    (with pkgs; {
      inherit acl attr automoc4 avahi bison cdparanoia cfitsio cups
              djvulibre docbook_xml_dtd_42 docbook_xsl enchant eigen2
              exiv2 fam ffmpeg flac flex freetype gmp gettext gpgme
              grantlee gsl hunspell ilmbase intltool jasper lcms2
              libgcrypt libraw libssh libspectre libvncserver libical
              networkmanager openal opencv openexr phonon pkgconfig
              polkit_qt4 prison python qca2 qimageblitz qjson qt4
              samba saneBackends soprano
              speechd strigi taglib udev xplanet xscreensaver xz;
      alsa = alsaLib;
      assuan = libassuan;
      boost = boost156;
      canberra = libcanberra;
      epub = ebook_tools;
      gphoto2 = libgphoto2;
      hupnp = herqq;
      indi = indilib;
      ldap = openldap;
      libattica = attica;
      musicbrainz3 = libmusicbrainz;
      oggvorbis = libvorbis;
      poppler = poppler_qt4;
      pulseaudio = libpulseaudio;
      qalculate = libqalculate;
      sasl2 = cyrus_sasl;
      shareddesktopontologies = shared_desktop_ontologies;
      sndfile = libsndfile;
      tiff = libtiff;
      telepathyqt4 = telepathy_qt;
      tunepimp = libtunepimp;
      usb = libusb;
      xsltproc = libxslt;
    });

  self =
    (builtins.removeAttrs super [ "artikulate" # build failure; wrong boost?
      "kde-dev-scripts" "kde-dev-utils" # docbook errors
      "kdewebdev" # unknown build failure
    ]) // {
      inherit kdePackage qt5 scope;

      ark = overrideDerivation super.ark (drv: {
        buildInputs = (drv.buildInputs or []) ++ [ pkgs.makeWrapper ];
        # runtime dependency
        postInstall = (drv.postInstall or "") + ''
          wrapProgram $out/bin/ark --prefix PATH : "${pkgs.unzipNLS}/bin"
        '';
      });

      ffmpegthumbs = overrideDerivation super.ffmpegthumbs (drv: {
        nativeBuildInputs = (drv.nativeBuildInputs or []) ++ [ scope.pkgconfig ];
      });

      kaccounts-providers = overrideDerivation super.kaccounts-providers (drv: {
        buildInputs = (drv.buildInputs or []) ++ [ pkgs.libaccounts-glib ];
        # hard-coded install path
        preConfigure = (drv.preConfigure or "") + ''
          substituteInPlace webkit-options/CMakeLists.txt \
            --replace "/etc/signon-ui/webkit-options.d/" \
                      "$out/etc/signon-ui/webkit-options.d/"
        '';
      });

      kalzium = overrideDerivation super.kalzium (drv: {
        nativeBuildInputs = (drv.nativeBuildInputs or []) ++ [ scope.pkgconfig ];
      });

      kate = overrideDerivation super.kate (drv: {
        buildInputs =
          (drv.buildInputs or [])
          ++ (with kf5; [ kconfig kguiaddons kiconthemes ki18n kinit kjobwidgets
                          kio kparts ktexteditor kwindowsystem kxmlgui ]);
        nativeBuildInputs = (drv.nativeBuildInputs or []) ++ ([ kf5.kdoctools ]);
      });

      /*
      kde-baseapps = overrideDerivation super.kde-baseapps (drv: {
        buildInputs = (drv.buildInputs or []) ++ [ scope.qt4 ];
      });
      */

      kde-runtime = overrideDerivation super.kde-runtime (drv: {
        buildInputs = (drv.buildInputs or []) ++ [ scope.canberra ];
        nativeBuildInputs = (drv.nativeBuildInputs or []) ++ [ scope.pkgconfig ];
        # cmake does not detect path to `ilmbase`
        NIX_CFLAGS_COMPILE =
          (drv.NIX_CFLAGS_COMPILE or "") + " -I${scope.ilmbase}/include/OpenEXR";
        # some components of this package have been replaced in other packages
        meta = { priority = 10; };
      });

      kde-workspace = overrideDerivation super.kde-workspace (drv: {
        buildInputs =
          (drv.buildInputs or []) ++
          (with pkgs.xlibs; [
            libxkbfile libXcomposite xcbutilimage xcbutilkeysyms xcbutilrenderutil
          ]);
        nativeBuildInputs = (drv.nativeBuildInputs or []) ++ [ scope.pkgconfig ];
        # some components of this package have been replaced in other packages
        meta = { priority = 10; };
      });

      kdelibs = overrideDerivation super.kdelibs (drv: {
        buildInputs =
          (drv.buildInputs or []) ++ (with scope; [ attr polkit_qt4 xsltproc xz ]);

        nativeBuildInputs = (drv.nativeBuildInputs or []) ++ [ scope.pkgconfig ];

        # cmake does not detect path to `ilmbase`
        NIX_CFLAGS_COMPILE =
          (drv.NIX_CFLAGS_COMPILE or "") + " -I${scope.ilmbase}/include/OpenEXR";

        propagatedBuildInputs =
          (drv.propagatedBuildInputs or [])
          ++ (with scope; [ qt4 soprano phonon strigi ]);

        propagatedNativeBuildInputs =
          (drv.propagatedNativeBuildInputs or [])
          ++ (with scope; [ automoc4 cmake perl sharedmimeinfo ]);

        patches = (drv.patches or []) ++ [ ./kdelibs/polkit-install.patch ];

        cmakeFlags = (drv.cmakeFlags or []) ++ [
          "-DDOCBOOKXML_CURRENTDTD_DIR=${scope.docbook_xml_dtd_42}/xml/dtd/docbook"
          "-DDOCBOOKXSL_DIR=${scope.docbook_xsl}/xml/xsl/docbook"
          "-DHUPNP_ENABLED=ON"
          "-DWITH_SOLID_UDISKS2=ON"
          "-DKDE_DEFAULT_HOME=.kde"
        ];
      });

      kdenlive = overrideDerivation super.kdenlive (drv: {
        buildInputs = (drv.buildInputs or []) ++ [ scope.mlt ];
      });

      kdepim = overrideDerivation super.kdepim (drv: {
        buildInputs = (drv.buildInputs or []) ++ (with scope; [ gpgme assuan ]);
        nativeBuildInputs = (drv.nativeBuildInputs or []) ++ [ scope.pkgconfig ];
      });

      kdepimlibs = overrideDerivation super.kdepimlibs (drv: {
        nativeBuildInputs = (drv.nativeBuildInputs or []) ++ [ scope.pkgconfig ];
      });

      kdesdk-thumbnailers = overrideDerivation super.kdesdk-thumbnailers (drv: {
        nativeBuildInputs = (drv.nativeBuildInputs or []) ++ [ scope.gettext ];
      });

      kgpg = overrideDerivation super.kgpg (drv: {
        buildInputs = (drv.buildInputs or []) ++ [ scope.boost ];
      });

      khangman = overrideDerivation super.khangman (drv: {
        buildInputs = (drv.buildInputs or []) ++ [ kf5.kio ];
      });

      kmix = overrideDerivation super.kmix (drv: {
        nativeBuildInputs = (drv.nativeBuildInputs or []) ++ [ scope.pkgconfig ];
        cmakeFlags = (drv.cmakeFlags or []) ++ [ "-DKMIX_KF5_BUILD=ON" ];
      });

      kmousetool = overrideDerivation super.kmousetool (drv: {
        buildInputs = (drv.buildInputs or []) ++ (with pkgs.xlibs; [ libXtst libXt ]);
      });

      kremotecontrol = overrideDerivation super.kremotecontrol (drv: {
        buildInputs = (drv.buildInputs or []) ++ [ pkgs.xlibs.libXtst ];
      });

      krfb = overrideDerivation super.krfb (drv: {
        buildInputs =
          (drv.buildInputs or [])
          ++ [ pkgs.xlibs.libXtst scope.ktp-common-internals ];
      });

      kstars = overrideDerivation super.kstars (drv: {
        buildInputs = (drv.buildInputs or []) ++ (with scope; [ kparts cfitsio ]);
      });

      ktp-accounts-kcm = overrideDerivation super.ktp-accounts-kcm (drv: {
        buildInputs = (drv.buildInputs or []) ++ [ pkgs.libaccounts-glib ];
      });

      ktp-common-internals = overrideDerivation super.ktp-common-internals (drv: {
        buildInputs =
          (drv.buildInputs or [])
          ++ (with scope; [ kdelibs4support kparts ])
          ++ [ pkgs.libotr ]; # needed for ktp-text-ui
      });

      ktp-text-ui = overrideDerivation super.ktp-text-ui (drv: {
        buildInputs = (drv.buildInputs or []) ++ [ scope.kdbusaddons ];
      });

      lokalize = overrideDerivation super.lokalize (drv: {
        buildInputs = (drv.buildInputs or []) ++ [ scope.kdbusaddons ];
      });

      libkdcraw = overrideDerivation super.libkdcraw (drv: {
        buildInputs = (drv.buildInputs or []) ++ (with scope; [ kdelibs libraw ]);
        nativeBuildInputs = (drv.nativeBuildInputs or []) ++ [ scope.pkgconfig ];
      });

      libkexiv2 = overrideDerivation super.libkexiv2 (drv: {
        buildInputs = (drv.buildInputs or []) ++ (with scope; [ exiv2 kdelibs ]);
      });

      libkface = overrideDerivation super.libkface (drv: {
        buildInputs = (drv.buildInputs or []) ++ (with scope; [ kdelibs opencv ]);
      });

      libkgeomap = overrideDerivation super.libkgeomap (drv: {
        cmakeFlags =
          (drv.cmakeFlags or [])
          ++ [ "-DCMAKE_MODULE_PATH=${scope.marble}/share/apps/cmake/modules" ];
      });

      libkipi = overrideDerivation super.libkipi (drv: {
        buildInputs = (drv.buildInputs or []) ++ [ scope.kdelibs ];
      });

      libksane = overrideDerivation super.libksane (drv: {
        buildInputs = (drv.buildInputs or []) ++ (with scope; [ kdelibs saneBackends]);
      });

      okular = overrideDerivation super.okular (drv: {
        nativeBuildInputs = (drv.nativeBuildInputs or []) ++ [ scope.pkgconfig ];
      });

      rocs = overrideDerivation super.rocs (drv: {
        buildInputs = (drv.buildInputs or []) ++ [ scope.kdelibs4support ];
      });

      signon-kwallet-extension =
        overrideDerivation super.signon-kwallet-extension (drv: {
          buildInputs = (drv.buildInputs or []) ++ [ scope.signonqt5 ];
          preConfigure = (drv.preConfigure or "") + ''
            sed -i src/CMakeLists.txt \
                -e "s,\''${SIGNONEXTENSION_PLUGINDIR},$out/lib/signon/extensions,"
          '';
        });

    };

in self
