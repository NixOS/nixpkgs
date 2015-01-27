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

{ autonix, kde4, kf55, pkgs, qt4, stdenv, debug ? false }:

with stdenv.lib; with autonix;

let

  kf5 = kf55.override { inherit debug; };

  mirror = "mirror://kde";

  renames =
    (builtins.removeAttrs
      (import ./renames.nix {})
      ["Backend" "CTest"])
    // {
      "KDE4" = "kdelibs";
      "Kexiv2" = "libkexiv2";
      "Kdcraw" = "libkdcraw";
      "Kipi" = "libkipi";
      "LibKMahjongg" = "libkmahjongg";
      "LibKonq" = "kde-baseapps";
    };

  scope =
    # packages in this collection
    (mapAttrs (dep: name: kdeApps."${name}") renames) //
    # packages from KDE Frameworks 5
    kf5.scope //
    # packages from nixpkgs
    (with pkgs;
      {
        ACL = acl;
        Akonadi = kde4.akonadi;
        Alsa = alsaLib;
        Automoc4 = automoc4;
        Avahi = avahi;
        BISON = bison;
        Baloo = kde4.baloo;
        Boost = boost156;
        Canberra = libcanberra;
        Cdparanoia = cdparanoia;
        CUPS = cups;
        DBusMenuQt = libdbusmenu_qt;
        DjVuLibre = djvulibre;
        ENCHANT = enchant;
        EPub = ebook_tools;
        Eigen2 = eigen2;
        Eigen3 = eigen;
        Exiv2 = exiv2;
        FAM = fam;
        FFmpeg = ffmpeg;
        Flac = flac;
        FLEX = flex;
        Freetype = freetype;
        GMP = gmp;
        Gettext = gettext;
        Gpgme = gpgme;
        Gphoto2 = libgphoto2;
        Grantlee = grantlee;
        GSL = gsl;
        HUNSPELL = hunspell;
        HUpnp = herqq;
        Jasper = jasper;
        KActivities = kde4.kactivities;
        LCMS2 = lcms2;
        Ldap = openldap;
        LibAttica = attica;
        LibGcrypt = libgcrypt;
        LibSSH = libssh;
        LibSpectre = libspectre;
        LibVNCServer = libvncserver;
        Libical = libical;
        MusicBrainz3 = libmusicbrainz;
        NetworkManager = networkmanager;
        OggVorbis = libvorbis;
        OpenAL = openal;
        OpenEXR = openexr;
        Poppler = poppler.poppler_qt4;
        Prison = prison;
        PulseAudio = pulseaudio;
        PythonLibrary = python;
        Qalculate = libqalculate;
        QCA2 = qca2;
        QImageBlitz = qimageblitz;
        QJSON = qjson;
        Qt4 = qt4;
        Samba = samba;
        Sasl2 = cyrus_sasl;
        SharedDesktopOntologies = shared_desktop_ontologies;
        SndFile = libsndfile;
        Speechd = speechd;
        TIFF = libtiff;
        Taglib = taglib;
        TelepathyQt4 = telepathy_qt;
        TunePimp = libtunepimp;
        UDev = udev;
        USB = libusb;
        Xscreensaver = xscreensaver;
        Xsltproc = libxslt;
      }
    );

  preResolve = super:
    fold (f: x: f x) super
      [
        (userEnvPkg "SharedMimeInfo")
        (userEnvPkg "SharedDesktopOntologies")
        (blacklist ["artikulate"]) # build failure, wrong boost?
        (blacklist ["kde-dev-scripts" "kde-dev-utils"]) # docbook errors
        (blacklist ["kdewebdev"]) # unknown build failure
      ];

  postResolve = super:
    super // {

      ark = with pkgs; super.ark // {
        buildInputs = (super.ark.buildInputs or []) ++ [ makeWrapper ];
        postInstall = ''
          wrapProgram $out/bin/ark --prefix PATH : "${unzipNLS}/bin"
        '';
      };

      ffmpegthumbs = with pkgs; super.ffmpegthumbs // {
        nativeBuildInputs = super.ffmpegthumbs.nativeBuildInputs ++ [pkgconfig];
      };

      kalzium = with pkgs; super.kalzium // {
        nativeBuildInputs = super.kalzium.nativeBuildInputs ++ [pkgconfig];
      };

      kde-runtime = with pkgs; super.kde-runtime // {
        buildInputs =
          super.kde-runtime.buildInputs ++ [libcanberra];
        nativeBuildInputs =
          super.kde-runtime.nativeBuildInputs ++ [pkgconfig];
        NIX_CFLAGS_COMPILE =
          (super.kde-runtime.NIX_CFLAGS_COMPILE or "")
          + " -I${ilmbase}/include/OpenEXR";
      };

      kde-workspace = with pkgs; super.kde-workspace // {
        buildInputs = with xlibs;
          super.kde-workspace.buildInputs
          ++
          [
            libxkbfile libXcomposite xcbutilimage xcbutilkeysyms
            xcbutilrenderutil
          ];
        nativeBuildInputs =
          super.kde-workspace.nativeBuildInputs
          ++ [ pkgconfig ];
      };

      kdelibs = with pkgs; super.kdelibs // {
        buildInputs =
          super.kdelibs.buildInputs ++ [ attr libxslt polkit_qt4 xz ];

        nativeBuildInputs =
          super.kdelibs.nativeBuildInputs ++ [ pkgconfig ];

        NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

        propagatedBuildInputs =
          super.kdelibs.propagatedBuildInputs ++ [ qt4 soprano phonon strigi ];

        propagatedNativeBuildInputs =
          super.kdelibs.propagatedNativeBuildInputs
          ++ [ automoc4 cmake perl shared_mime_info ];

        patches = [ ./kdelibs/polkit-install.patch ];

        cmakeFlags = [
          "-DDOCBOOKXML_CURRENTDTD_DIR=${docbook_xml_dtd_42}/xml/dtd/docbook"
          "-DDOCBOOKXSL_DIR=${docbook_xsl}/xml/xsl/docbook"
          "-DHUPNP_ENABLED=ON"
          "-DWITH_SOLID_UDISKS2=ON"
        ];
      };

      kdepim = with pkgs; super.kdepim // {
        buildInputs =
          super.kdepim.buildInputs ++ [ gpgme libassuan ];
        nativeBuildInputs =
          super.kdepim.nativeBuildInputs ++ [ pkgconfig ];
      };

      kdepimlibs = with pkgs; super.kdepimlibs // {
        nativeBuildInputs =
          super.kdepimlibs.nativeBuildInputs ++ [ pkgconfig ];
      };

      kdesdk-thumbnailers = with pkgs; super.kdesdk-thumbnailers // {
        nativeBuildInputs =
          super.kdesdk-thumbnailers.nativeBuildInputs
          ++ [gettext];
      };

      kgpg = with pkgs; super.kgpg // {
        buildInputs = super.kgpg.buildInputs ++ [boost];
      };

      kmix = with pkgs; super.kmix // {
        nativeBuildInputs = super.kmix.nativeBuildInputs ++ [pkgconfig];
        cmakeFlags = [ "-DKMIX_KF5_BUILD=ON" ];
      };

      kmousetool = with pkgs; super.kmousetool // {
        buildInputs = with xlibs;
          super.kmousetool.buildInputs
          ++ [libXtst libXt];
      };

      kremotecontrol = with pkgs; super.kremotecontrol // {
        buildInputs = super.kremotecontrol.buildInputs ++ [xlibs.libXtst];
      };

      krfb = with pkgs; super.krfb // {
        buildInputs =
          super.krfb.buildInputs
          ++ [xlibs.libXtst kde4.telepathy.common_internals];
      };

      libkdcraw = with pkgs; super.libkdcraw // {
        buildInputs = super.libkdcraw.buildInputs ++ [scope.KDE4 libraw];
        nativeBuildInputs = super.libkdcraw.nativeBuildInputs ++ [pkgconfig];
      };

      libkexiv2 = with pkgs; super.libkexiv2 // {
        buildInputs = super.libkexiv2.buildInputs ++ [exiv2 scope.KDE4];
      };

      libkface = with pkgs; super.libkface // {
        buildInputs = super.libkface.buildInputs ++ [scope.KDE4 opencv];
      };

      libkipi = with pkgs; super.libkipi // {
        buildInputs = super.libkipi.buildInputs ++ [scope.KDE4];
      };

      libksane = with pkgs; super.libksane // {
        buildInputs = super.libksane.buildInputs ++ [scope.KDE4 saneBackends];
      };

    };

  kdeApps = generateCollection ./. {
    inherit (kf5) mkDerivation;
    inherit mirror preResolve postResolve renames scope;
  };

in kdeApps
