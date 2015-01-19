{ autonix, kde4, kf55, pkgs, qt4, stdenv, debug ? false }:

with stdenv.lib; with autonix;

let

  kf5 = kf55.override { inherit debug; };

  mirror = "mirror://kde";

  renames =
    builtins.removeAttrs
      (import ./renames.nix {})
      ["Backend" "CTest"];

  scope =
    # packages in this collection
    (mapAttrs (dep: name: kdeApps."${name}") renames) //
    # packages from KDE Frameworks 5
    kf5.scope //
    # packages from nixpkgs
    (with pkgs;
      {
        Alsa = alsaLib;
        Cdparanoia = cdparanoia;
        CUPS = cups;
        DjVuLibre = djvulibre;
        EPub = ebook_tools;
        Eigen2 = eigen2;
        Eigen3 = eigen;
        Exiv2 = exiv2;
        FFmpeg = ffmpeg;
        Flac = flac;
        Freetype = freetype;
        GMP = gmp;
        Gettext = gettext;
        Gpgme = gpgme;
        Gphoto2 = libgphoto2;
        Grantlee = grantlee;
        GSL = gsl;
        HUNSPELL = hunspell;
        KActivities = kde4.kactivities;
        KDE4 = kde4.kdelibs;
        KDE4Workspace = kde4.kde_workspace;
        Kexiv2 = kdeApps.libkexiv2;
        Kdcraw = kdeApps.libkdcraw;
        KdepimLibs = kde4.kdepimlibs;
        Kipi = kdeApps.libkipi;
        LCMS2 = lcms2;
        LibAttica = attica;
        LibGcrypt = libgcrypt;
        LibKMahjongg = kdeApps.libkmahjongg;
        LibKonq = kdeApps.kde-baseapps;
        LibSSH = libssh;
        LibSpectre = libspectre;
        LibVNCServer = libvncserver;
        MusicBrainz3 = libmusicbrainz;
        NetworkManager = networkmanager;
        OggVorbis = libvorbis;
        OpenAL = openal;
        OpenEXR = openexr;
        Poppler = poppler.poppler_qt4;
        PulseAudio = pulseaudio;
        Qalculate = libqalculate;
        QCA2 = qca2;
        Samba = samba;
        SndFile = libsndfile;
        Speechd = speechd;
        TIFF = libtiff;
        Taglib = taglib;
        TelepathyQt4 = telepathy_qt;
        TunePimp = libtunepimp;
        Xscreensaver = xscreensaver;
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
        buildInputs = super.libkdcraw.buildInputs ++ [kde4.kdelibs libraw];
        nativeBuildInputs = super.libkdcraw.nativeBuildInputs ++ [pkgconfig];
      };

      libkexiv2 = with pkgs; super.libkexiv2 // {
        buildInputs = super.libkexiv2.buildInputs ++ [exiv2 kde4.kdelibs];
      };

      libkface = with pkgs; super.libkface // {
        buildInputs = super.libkface.buildInputs ++ [kde4.kdelibs opencv];
      };

      libkipi = with pkgs; super.libkipi // {
        buildInputs = super.libkipi.buildInputs ++ [kde4.kdelibs];
      };

      libksane = with pkgs; super.libksane // {
        buildInputs = super.libksane.buildInputs ++ [kde4.kdelibs saneBackends];
      };

      okular = with pkgs; super.okular // {
        buildInputs = super.okular.buildInputs ++ [ebook_tools];
      };

    };

  kdeApps = generateCollection ./. {
    inherit (kf5) mkDerivation;
    inherit mirror preResolve postResolve scope;
  };

in kdeApps
