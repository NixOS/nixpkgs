{ lib, stdenv, callPackage, fetchFromGitHub
, cmake, kodi, libcec_platform, tinyxml, pugixml
, steam, udev, libusb1, jsoncpp, libhdhomerun, zlib
, python3Packages, expat, glib, nspr, nss, openssl
, libssh, libarchive, lzma, bzip2, lz4, lzo }:

with lib;

let self = rec {

  addonDir = "/share/kodi/addons";
  rel = "Matrix";

  inherit kodi;

  # Convert derivation to a kodi module. Stolen from ../../../top-level/python-packages.nix
  toKodiAddon = drv: drv.overrideAttrs(oldAttrs: {
    # Use passthru in order to prevent rebuilds when possible.
    passthru = (oldAttrs.passthru or {})// {
      kodiAddonFor = kodi;
      requiredKodiAddons = requiredKodiAddons drv.propagatedBuildInputs;
    };
  });

  # Check whether a derivation provides a Kodi addon.
  hasKodiAddon = drv: drv ? kodiAddonFor && drv.kodiAddonFor == kodi;

  # Get list of required Kodi addons given a list of derivations.
  requiredKodiAddons = drvs: let
      modules = filter hasKodiAddon drvs;
    in unique (modules ++ concatLists (catAttrs "requiredKodiAddons" modules));

  kodi-platform = stdenv.mkDerivation rec {
    project = "kodi-platform";
    version = "17.1";
    name = "${project}-${version}";

    src = fetchFromGitHub {
      owner = "xbmc";
      repo = project;
      rev = "c8188d82678fec6b784597db69a68e74ff4986b5";
      sha256 = "1r3gs3c6zczmm66qcxh9mr306clwb3p7ykzb70r3jv5jqggiz199";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ kodi libcec_platform tinyxml ];
  };

  buildKodiAddon =
    { name ? "${attrs.pname}-${attrs.version}"
    , namespace
    , sourceDir ? ""
    , ... } @ attrs:
  toKodiAddon (stdenv.mkDerivation ({
    name = "kodi-" + name;

    dontStrip = true;

    extraRuntimeDependencies = [ ];

    installPhase = ''
      cd $src/$sourceDir
      d=$out${addonDir}/${namespace}
      mkdir -p $d
      sauce="."
      [ -d ${namespace} ] && sauce=${namespace}
      cp -R "$sauce/"* $d
    '';
  } // attrs));

  buildKodiBinaryAddon =
    { name ? "${attrs.pname}-${attrs.version}"
    , namespace
    , version
    , extraBuildInputs ? []
    , extraRuntimeDependencies ? []
    , extraInstallPhase ? "", ... } @ attrs:
  toKodiAddon (stdenv.mkDerivation ({
    name = "kodi-" + name;

    dontStrip = true;

    nativeBuildInputs = [ cmake ];
    buildInputs = [ kodi kodi-platform libcec_platform ] ++ extraBuildInputs;

    inherit extraRuntimeDependencies;

    # disables check ensuring install prefix is that of kodi
    cmakeFlags = [
      "-DOVERRIDE_PATHS=1"
    ];

    # kodi checks for addon .so libs existance in the addon folder (share/...)
    # and the non-wrapped kodi lib/... folder before even trying to dlopen
    # them. Symlinking .so, as setting LD_LIBRARY_PATH is of no use
    installPhase = let n = namespace; in ''
      make install
      ln -s $out/lib/addons/${n}/${n}.so.${version} $out${addonDir}/${n}/${n}.so.${version}
      ${extraInstallPhase}
    '';
  } // attrs));

  controllers = let
    pname = "game-controller";
    version = "1.0.3";

    src = fetchFromGitHub {
      owner = "kodi-game";
      repo = "kodi-game-controllers";
      rev = "01acb5b6e8b85392b3cb298b034aadb1b24ccf18";
      sha256 = "0sbc0w0fwbp7rbmbgb6a1kglhnn5g85hijcbbvf5x6jdq9v3f1qb";
    };

    meta = {
      description = "Add support for different gaming controllers.";
      platforms = platforms.all;
      maintainers = with maintainers; [ edwtjo ];
    };

    mkController = controller: {
        ${controller} = buildKodiAddon rec {
          pname = pname + "-" + controller;
          namespace = "game.controller." + controller;
          sourceDir = "addons/" + namespace;
          inherit version src meta;
        };
      };
    in (mkController "dreamcast")
    // (mkController "gba")
    // (mkController "genesis")
    // (mkController "mouse")
    // (mkController "n64")
    // (mkController "nes")
    // (mkController "ps");

  joystick = buildKodiBinaryAddon rec {
    pname = namespace;
    namespace = "peripheral.joystick";
    version = "1.7.1";

    src = fetchFromGitHub {
      owner = "xbmc";
      repo = namespace;
      rev = "${version}-${rel}";
      sha256 = "1dhj4afr9kj938xx70fq5r409mz6lbw4n581ljvdjj9lq7akc914";
    };

    meta = {
      description = "Binary addon for raw joystick input.";
      platforms = platforms.all;
      maintainers = with maintainers; [ edwtjo ];
    };

    extraBuildInputs = [ tinyxml udev ];
  };

  svtplay = buildKodiAddon rec {

    pname = "svtplay";
    namespace = "plugin.video.svtplay";
    version = "5.1.12";

    src = fetchFromGitHub {
      name = pname + "-" + version + ".tar.gz";
      owner = "nilzen";
      repo = "xbmc-" + pname;
      rev = "v${version}";
      sha256 = "04j1nhm7mh9chs995lz6bv1vsq5xzk7a7c0lmk4bnfv8jrfpj0w6";
    };

    meta = {
      homepage = "https://forum.kodi.tv/showthread.php?tid=67110";
      description = "Watch content from SVT Play";
      longDescription = ''
        With this addon you can stream content from SVT Play
        (svtplay.se). The plugin fetches the video URL from the SVT
        Play website and feeds it to the Kodi video player. HLS (m3u8)
        is the preferred video format by the plugin.
      '';
      platforms = platforms.all;
      maintainers = with maintainers; [ edwtjo ];
    };

  };

  steam-controller = buildKodiBinaryAddon rec {
    pname = namespace;
    namespace = "peripheral.steamcontroller";
    version = "0.11.0";

    src = fetchFromGitHub {
      owner = "kodi-game";
      repo = namespace;
      rev = "f68140ca44f163a03d3a625d1f2005a6edef96cb";
      sha256 = "09lm8i119xlsxxk0c64rnp8iw0crr90v7m8iwi9r31qdmxrdxpmg";
    };

    extraBuildInputs = [ libusb1 ];

    meta = {
      description = "Binary addon for steam controller.";
      platforms = platforms.all;
      maintainers = with maintainers; [ edwtjo ];
    };

  };

  steam-launcher = buildKodiAddon {

    pname = "steam-launcher";
    namespace = "script.steam.launcher";
    version = "3.5.1";

    src = fetchFromGitHub rec {
      owner = "teeedubb";
      repo = owner + "-xbmc-repo";
      rev = "8260bf9b464846a1f1965da495d2f2b7ceb81d55";
      sha256 = "1fj3ry5s44nf1jzxk4bmnpa4b9p23nrpmpj2a4i6xf94h7jl7p5k";
    };

    propagatedBuildInputs = [ steam ];

    meta = {
      homepage = "https://forum.kodi.tv/showthread.php?tid=157499";
      description = "Launch Steam in Big Picture Mode from Kodi";
      longDescription = ''
        This add-on will close/minimise Kodi, launch Steam in Big
        Picture Mode and when Steam BPM is exited (either by quitting
        Steam or returning to the desktop) Kodi will
        restart/maximise. Running pre/post Steam scripts can be
        configured via the addon.
      '';
      maintainers = with maintainers; [ edwtjo ];
    };
  };

  pdfreader = buildKodiAddon rec {
    pname = "pdfreader";
    namespace = "plugin.image.pdf";
    version = "2.0.2";

    src = fetchFromGitHub {
      owner = "i96751414";
      repo = "plugin.image.pdfreader";
      rev = "v${version}";
      sha256 = "0nkqhlm1gyagq6xpdgqvd5qxyr2ngpml9smdmzfabc8b972mwjml";
    };

    meta = {
      homepage = "https://forum.kodi.tv/showthread.php?tid=187421";
      description = "A comic book reader";
      maintainers = with maintainers; [ edwtjo ];
    };
  };

  pvr-hts = buildKodiBinaryAddon rec {

    pname = "pvr-hts";
    namespace = "pvr.hts";
    version = "8.2.2";

    src = fetchFromGitHub {
      owner = "kodi-pvr";
      repo = "pvr.hts";
      rev = "${version}-${rel}";
      sha256 = "0jnn9gfjl556acqjf92wzzn371gxymhbbi665nqgg2gjcan0a49q";
    };

    meta = {
      homepage = "https://github.com/kodi-pvr/pvr.hts";
      description = "Kodi's Tvheadend HTSP client addon";
      platforms = platforms.all;
      maintainers = with maintainers; [ cpages ];
    };

  };

  pvr-hdhomerun = buildKodiBinaryAddon rec {

    pname = "pvr-hdhomerun";
    namespace = "pvr.hdhomerun";
    version = "7.1.0";

    src = fetchFromGitHub {
      owner = "kodi-pvr";
      repo = "pvr.hdhomerun";
      rev = "${version}-${rel}";
      sha256 = "0gbwjssnd319csq2kwlyjj1rskg19m1dxac5dl2dymvx5hn3zrgm";
    };

    meta = {
      homepage = "https://github.com/kodi-pvr/pvr.hdhomerun";
      description = "Kodi's HDHomeRun PVR client addon";
      platforms = platforms.all;
      maintainers = with maintainers; [ titanous ];
    };

    extraBuildInputs = [ jsoncpp libhdhomerun ];

  };

  pvr-iptvsimple = buildKodiBinaryAddon rec {

    pname = "pvr-iptvsimple";
    namespace = "pvr.iptvsimple";
    version = "7.4.2";

    src = fetchFromGitHub {
      owner = "kodi-pvr";
      repo = "pvr.iptvsimple";
      rev = "${version}-${rel}";
      sha256 = "062i922qi0izkvn7v47yhyy2cf3fa7xc3k95b1gm9abfdwkk8ywr";
    };

    meta = {
      homepage = "https://github.com/kodi-pvr/pvr.iptvsimple";
      description = "Kodi's IPTV Simple client addon";
      platforms = platforms.all;
      maintainers = with maintainers; [ ];
      license = licenses.gpl2Plus;
    };

    extraBuildInputs = [ zlib pugixml ];
  };

  osmc-skin = buildKodiAddon rec {

    pname = "osmc-skin";
    namespace = "skin.osmc";
    version = "18.0.0";

    src = fetchFromGitHub {
      owner = "osmc";
      repo = namespace;
      rev = "40a6c318641e2cbeac58fb0e7dde9c2beac737a0";
      sha256 = "1l7hyfj5zvjxjdm94y325bmy1naak455b9l8952sb0gllzrcwj6s";
    };

    meta = {
      homepage = "https://github.com/osmc/skin.osmc";
      description = "The default skin for OSMC";
      platforms = platforms.all;
      maintainers = with maintainers; [ worldofpeace ];
      license = licenses.cc-by-nc-sa-30;
    };
  };

  inputstream-adaptive = buildKodiBinaryAddon rec {

    pname = "inputstream-adaptive";
    namespace = "inputstream.adaptive";
    version = "2.6.7";

    src = fetchFromGitHub {
      owner = "peak3d";
      repo = "inputstream.adaptive";
      rev = "${version}-${rel}";
      sha256 = "1pwqmbr78wp12jn6rwv63npdfc456adwz0amlxf6gvgg43li6p7s";
    };

    extraBuildInputs = [ expat ];

    extraRuntimeDependencies = [ glib nspr nss stdenv.cc.cc.lib ];

    extraInstallPhase = let n = namespace; in ''
      ln -s $out/lib/addons/${n}/libssd_wv.so $out/${addonDir}/${n}/libssd_wv.so
    '';

    meta = {
      homepage = "https://github.com/peak3d/inputstream.adaptive";
      description = "Kodi inputstream addon for several manifest types";
      platforms = platforms.all;
      maintainers = with maintainers; [ sephalon ];
    };
  };

  vfs-sftp = buildKodiBinaryAddon rec {
    pname = namespace;
    namespace = "vfs.sftp";
    version = "2.0.0";

    src = fetchFromGitHub {
      owner = "xbmc";
      repo = namespace;
      rev = "${version}-${rel}";
      sha256 = "06w74sh8yagrrp7a7rjaz3xrh1j3wdqald9c4b72c33gpk5997dk";
    };

    meta = with lib; {
      description = "SFTP Virtual Filesystem add-on for Kodi";
      license = licenses.gpl2Plus;
      platforms = platforms.all;
      maintainers = with maintainers; [ minijackson ];
    };

    extraBuildInputs = [ openssl libssh zlib ];
  };

  vfs-libarchive = buildKodiBinaryAddon rec {
    pname = namespace;
    namespace = "vfs.libarchive";
    version = "2.0.0";

    src = fetchFromGitHub {
      owner = "xbmc";
      repo = namespace;
      rev = "${version}-${rel}";
      sha256 = "1q62p1i6rvqk2zv6f1cpffkh95lgclys2xl4dwyhj3acmqdxd9i5";
    };

    meta = with lib; {
      description = "LibArchive Virtual Filesystem add-on for Kodi";
      license = licenses.gpl2Plus;
      platforms = platforms.all;
      maintainers = with maintainers; [ minijackson ];
    };

    extraBuildInputs = [ libarchive lzma bzip2 zlib lz4 lzo openssl ];
  };
}; in self
