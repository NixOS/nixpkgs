{ stdenv, callPackage, fetchFromGitHub
, cmake, kodiPlain, libcec_platform, tinyxml, rapidxml
, steam, udev, libusb1, jsoncpp, libhdhomerun, zlib
, python2Packages, expat, glib, nspr, nss, openssl
, libssh, libarchive, lzma, bzip2, lz4, lzo }:

with stdenv.lib;

let self = rec {

  pluginDir = "/share/kodi/addons";
  rel = "Leia";

  kodi = kodiPlain;

  # Convert derivation to a kodi module. Stolen from ../../../top-level/python-packages.nix
  toKodiPlugin = drv: drv.overrideAttrs(oldAttrs: {
    # Use passthru in order to prevent rebuilds when possible.
    passthru = (oldAttrs.passthru or {})// {
      kodiPluginFor = kodi;
      requiredKodiPlugins = requiredKodiPlugins drv.propagatedBuildInputs;
    };
  });

  # Check whether a derivation provides a Kodi plugin.
  hasKodiPlugin = drv: drv ? kodiPluginFor && drv.kodiPluginFor == kodi;

  # Get list of required Kodi plugins given a list of derivations.
  requiredKodiPlugins = drvs: let
      modules = filter hasKodiPlugin drvs;
    in unique (modules ++ concatLists (catAttrs "requiredKodiPlugins" modules));

  kodiWithPlugins = func: callPackage ./wrapper.nix {
    inherit kodi;
    plugins = requiredKodiPlugins (func self);
  };

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

    buildInputs = [ cmake kodiPlain libcec_platform tinyxml ];
  };

  mkKodiPlugin = { plugin, namespace, version, sourceDir ? null, ... }@args:
  toKodiPlugin (stdenv.mkDerivation ({
    name = "kodi-plugin-${plugin}-${version}";

    dontStrip = true;

    extraRuntimeDependencies = [ ];

    installPhase = ''
      ${if sourceDir == null then "" else "cd $src/$sourceDir"}
      d=$out${pluginDir}/${namespace}
      mkdir -p $d
      sauce="."
      [ -d ${namespace} ] && sauce=${namespace}
      cp -R "$sauce/"* $d
    '';
  } // args));

  mkKodiABIPlugin = { plugin, namespace, version, extraBuildInputs ? [],
    extraRuntimeDependencies ? [], extraInstallPhase ? "", ... }@args:
  toKodiPlugin (stdenv.mkDerivation ({
    name = "kodi-plugin-${plugin}-${version}";

    dontStrip = true;

    buildInputs = [ cmake kodiPlain kodi-platform libcec_platform ]
               ++ extraBuildInputs;

    inherit extraRuntimeDependencies;

    # disables check ensuring install prefix is that of kodi
    cmakeFlags = [
      "-DOVERRIDE_PATHS=1"
    ];

    # kodi checks for plugin .so libs existance in the addon folder (share/...)
    # and the non-wrapped kodi lib/... folder before even trying to dlopen
    # them. Symlinking .so, as setting LD_LIBRARY_PATH is of no use
    installPhase = let n = namespace; in ''
      make install
      ln -s $out/lib/addons/${n}/${n}.so.${version} $out${pluginDir}/${n}/${n}.so.${version}
      ${extraInstallPhase}
    '';
  } // args));

  advanced-launcher = mkKodiPlugin rec {

    plugin = "advanced-launcher";
    namespace = "plugin.program.advanced.launcher";
    version = "2.5.8";

    src = fetchFromGitHub {
      owner = "edwtjo";
      repo = plugin;
      rev = version;
      sha256 = "142vvgs37asq5m54xqhjzqvgmb0xlirvm0kz6lxaqynp0vvgrkx2";
    };

    meta = {
      homepage = "https://forum.kodi.tv/showthread.php?tid=85724";
      description = "A program launcher for Kodi";
      longDescription = ''
        Advanced Launcher allows you to start any Linux, Windows and
        macOS external applications (with command line support or not)
        directly from the Kodi GUI. Advanced Launcher also give you
        the possibility to edit, download (from Internet resources)
        and manage all the meta-data (informations and images) related
        to these applications.
      '';
      platforms = platforms.all;
      maintainers = with maintainers; [ edwtjo ];
    };

  };

  advanced-emulator-launcher = mkKodiPlugin rec {

    plugin = "advanced-emulator-launcher";
    namespace = "plugin.program.advanced.emulator.launcher";
    version = "0.9.6";

    src = fetchFromGitHub {
      owner = "Wintermute0110";
      repo = namespace;
      rev = version;
      sha256 = "1sv9z77jj6bam6llcnd9b3dgkbvhwad2m1v541rv3acrackms2z2";
    };

    meta = {
      homepage = "https://forum.kodi.tv/showthread.php?tid=287826";
      description = "A program launcher for Kodi";
      longDescription = ''
        Advanced Emulator Launcher is a multi-emulator front-end for Kodi
        scalable to collections of thousands of ROMs. Includes offline scrapers
        for MAME and No-Intro ROM sets and also supports scrapping ROM metadata
        and artwork online. ROM auditing for No-Intro ROMs using No-Intro XML
        DATs. Launching of games and standalone applications is also available.
      '';
      platforms = platforms.all;
      maintainers = with maintainers; [ edwtjo ];
    };

  };

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
        ${controller} = mkKodiPlugin rec {
          plugin = pname + "-" + controller;
          namespace = "game.controller." + controller;
          sourceDir = "addons/" + namespace;
          inherit version src meta;
        };
      };
    in (mkController "default")
    // (mkController "dreamcast")
    // (mkController "gba")
    // (mkController "genesis")
    // (mkController "mouse")
    // (mkController "n64")
    // (mkController "nes")
    // (mkController "ps")
    // (mkController "snes");

  hyper-launcher = let
    pname = "hyper-launcher";
    version = "1.5.2";
    src = fetchFromGitHub rec {
      name = pname + "-" + version + ".tar.gz";
      owner = "teeedubb";
      repo = owner + "-xbmc-repo";
      rev = "f958ba93fe85b9c9025b1745d89c2db2e7dd9bf6";
      sha256 = "1dvff24fbas25k5kvca4ssks9l1g5rfa3hl8lqxczkaqi3pp41j5";
    };
    meta = {
      homepage = "https://forum.kodi.tv/showthread.php?tid=258159";
      description = "A ROM launcher for Kodi that uses HyperSpin assets.";
      maintainers = with maintainers; [ edwtjo ];
    };
  in {
    service = mkKodiPlugin {
      plugin = pname + "-service";
      version = "1.2.1";
      namespace = "service.hyper.launcher";
      inherit src meta;
    };
    plugin = mkKodiPlugin {
      plugin = pname;
      namespace = "plugin.hyper.launcher";
      inherit version src meta;
    };
  };

  joystick = mkKodiABIPlugin rec {
    namespace = "peripheral.joystick";
    version = "1.4.7";
    plugin = namespace;

    src = fetchFromGitHub {
      owner = "xbmc";
      repo = namespace;
      rev = "v${version}";
      sha256 = "03gsp4kg41s3n4ib4wsv7m3krfipgwc2z07i4mnd5zvg0c4xrmap";
    };

    meta = {
      description = "Binary addon for raw joystick input.";
      platforms = platforms.all;
      maintainers = with maintainers; [ edwtjo ];
    };

    extraBuildInputs = [ udev ];
  };

  simpleplugin = mkKodiPlugin rec {
    plugin = "simpleplugin";
    namespace = "script.module.simpleplugin";
    version = "2.3.2";

    src = fetchFromGitHub {
      owner = "romanvm";
      repo = namespace;
      rev = "v.${version}";
      sha256 = "0myar8dqjigb75pcc8zx3i5z79p1ifgphgb82s5syqywk0zaxm3j";
    };

    meta = {
      homepage = src.meta.homepage;
      description = "Simpleplugin API";
      license = licenses.gpl3;
    };
  };

  svtplay = mkKodiPlugin rec {

    plugin = "svtplay";
    namespace = "plugin.video.svtplay";
    version = "4.0.48";

    src = fetchFromGitHub {
      name = plugin + "-" + version + ".tar.gz";
      owner = "nilzen";
      repo = "xbmc-" + plugin;
      rev = "dc18ad002cd69257611d0032fba91f57bb199165";
      sha256 = "0klk1jpjc243ak306k94mag4b4s17w68v69yb8lzzydszqkaqa7x";
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

  steam-controller = mkKodiABIPlugin rec {
    namespace = "peripheral.steamcontroller";
    version = "0.10.0";
    plugin = namespace;

    src = fetchFromGitHub {
      owner = "kodi-game";
      repo = namespace;
      rev = "ea345392ab5aa4485f3a48d2037fa8a8e8ab82de";
      sha256 = "1hbd8fdvn7xkr9csz1g9wah78nhnq1rkazl4zwa31y70830k3279";
    };

    extraBuildInputs = [ libusb1 ];

    meta = {
      description = "Binary addon for steam controller.";
      platforms = platforms.all;
      maintainers = with maintainers; [ edwtjo ];
    };

  };

  steam-launcher = mkKodiPlugin {

    plugin = "steam-launcher";
    namespace = "script.steam.launcher";
    version = "3.1.4";

    src = fetchFromGitHub rec {
      owner = "teeedubb";
      repo = owner + "-xbmc-repo";
      rev = "db67704c3e16bdcdd3bdfe2926c609f1f6bdc4fb";
      sha256 = "001a7zs3a4jfzj8ylxv2klc33mipmqsd5aqax7q81fbgwdlndvbm";
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

  pdfreader = mkKodiPlugin rec {
    plugin = "pdfreader";
    namespace = "plugin.image.pdf";
    version = "1.0.2";

    src = fetchFromGitHub rec {
      name = plugin + "-" + version + ".tar.gz";
      owner = "teeedubb";
      repo = owner + "-xbmc-repo";
      rev = "0a405b95208ced8a1365ad3193eade8d1c2117ce";
      sha256 = "1iv7d030z3xvlflvp4p5v3riqnwg9g0yvzxszy63v1a6x5kpjkqa";
    };

    meta = {
      homepage = "https://forum.kodi.tv/showthread.php?tid=187421";
      description = "A comic book reader";
      maintainers = with maintainers; [ edwtjo ];
    };
  };

  pvr-hts = mkKodiABIPlugin rec {

    plugin = "pvr-hts";
    namespace = "pvr.hts";
    version = "4.4.14";

    src = fetchFromGitHub {
      owner = "kodi-pvr";
      repo = "pvr.hts";
      rev = "${version}-${rel}";
      sha256 = "1bcwcwd2yjhw85yk6lyhf0iqiclrsz7r7vpbxgc650fwqbb146gr";
    };

    meta = {
      homepage = "https://github.com/kodi-pvr/pvr.hts";
      description = "Kodi's Tvheadend HTSP client addon";
      platforms = platforms.all;
      maintainers = with maintainers; [ cpages ];
    };

  };

  pvr-hdhomerun = mkKodiABIPlugin rec {

    plugin = "pvr-hdhomerun";
    namespace = "pvr.hdhomerun";
    version = "3.5.0";

    src = fetchFromGitHub {
      owner = "kodi-pvr";
      repo = "pvr.hdhomerun";
      rev = "${version}-${rel}";
      sha256 = "1zrkvfn0im2qmvqm93pa3cg8xkxv61sxlj8nsz4r5z9v9nhqadf6";
    };

    meta = {
      homepage = "https://github.com/kodi-pvr/pvr.hdhomerun";
      description = "Kodi's HDHomeRun PVR client addon";
      platforms = platforms.all;
      maintainers = with maintainers; [ titanous ];
    };

    extraBuildInputs = [ jsoncpp libhdhomerun ];

  };

  pvr-iptvsimple = mkKodiABIPlugin rec {

    plugin = "pvr-iptvsimple";
    namespace = "pvr.iptvsimple";
    version = "3.5.7";

    src = fetchFromGitHub {
      owner = "kodi-pvr";
      repo = "pvr.iptvsimple";
      rev = "${version}-${rel}";
      sha256 = "17znib7c491h2ii4gagxradh0jyvgga0d548gbk4yjj2nc9qqc6d";
    };

    meta = {
      homepage = "https://github.com/kodi-pvr/pvr.iptvsimple";
      description = "Kodi's IPTV Simple client addon";
      platforms = platforms.all;
      maintainers = with maintainers; [ ];
      license = licenses.gpl2Plus;
    };

    extraBuildInputs = [ zlib rapidxml ];
  };

  osmc-skin = mkKodiPlugin rec {

    plugin = "osmc-skin";
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

  yatp = python2Packages.toPythonModule (mkKodiPlugin rec {
    plugin = "yatp";
    namespace = "plugin.video.yatp";
    version = "3.3.2";

    src = fetchFromGitHub {
      owner = "romanvm";
      repo = "kodi.yatp";
      rev = "v.${version}";
      sha256 = "12g1f57sx7dy6wy7ljl7siz2qs1kxcmijcg7xx2xpvmq61x9qa2d";
    };

    patches = [ ./yatp/dont-monkey.patch ];

    propagatedBuildInputs = [
      simpleplugin
      python2Packages.requests
      python2Packages.libtorrent-rasterbar
    ];

    meta = {
      homepage = src.meta.homepage;
      description = "Yet Another Torrent Player: libtorrent-based torrent streaming for Kodi";
      license = licenses.gpl3;
    };
  });

  inputstream-adaptive = mkKodiABIPlugin rec {

    plugin = "inputstream-adaptive";
    namespace = "inputstream.adaptive";
    version = "2.4.6";

    src = fetchFromGitHub {
      owner = "peak3d";
      repo = "inputstream.adaptive";
      rev = "${version}-${rel}";
      sha256 = "09d9b35mpaf3g5m51viyan9hv7d2i8ndvb9wm0j7rs5gwsf0k71z";
    };

    extraBuildInputs = [ expat ];

    extraRuntimeDependencies = [ glib nspr nss stdenv.cc.cc.lib ];

    extraInstallPhase = let n = namespace; in ''
      ln -s $out/lib/addons/${n}/libssd_wv.so $out/${pluginDir}/${n}/libssd_wv.so
    '';

    meta = {
      homepage = "https://github.com/peak3d/inputstream.adaptive";
      description = "Kodi inputstream addon for several manifest types";
      platforms = platforms.all;
      maintainers = with maintainers; [ sephalon ];
    };
  };

  vfs-sftp = mkKodiABIPlugin rec {
    namespace = "vfs.sftp";
    version = "1.0.6";
    plugin = namespace;

    src = fetchFromGitHub {
      owner = "xbmc";
      repo = namespace;
      rev = "${version}-${rel}";
      sha256 = "044kkzcpzvbyih4vys33r4hqw38xa82snmvl4qj1r80wnszc8af1";
    };

    meta = with stdenv.lib; {
      description = "SFTP Virtual Filesystem add-on for Kodi";
      license = licenses.gpl2Plus;
      platforms = platforms.all;
      maintainers = with maintainers; [ minijackson ];
    };

    extraBuildInputs = [ openssl libssh zlib ];
  };

  vfs-libarchive = mkKodiABIPlugin rec {
    namespace = "vfs.libarchive";
    version = "1.0.7";
    plugin = namespace;

    src = fetchFromGitHub {
      owner = "xbmc";
      repo = namespace;
      rev = "${version}-${rel}";
      sha256 = "01qhv095h5j67ispm4iw18pd3kl7a0mnjkgm92al9qqiyif8lzgh";
    };

    meta = with stdenv.lib; {
      description = "LibArchive Virtual Filesystem add-on for Kodi";
      license = licenses.gpl2Plus;
      platforms = platforms.all;
      maintainers = with maintainers; [ minijackson ];
    };

    extraBuildInputs = [ libarchive lzma bzip2 zlib lz4 lzo openssl ];
  };
}; in self
