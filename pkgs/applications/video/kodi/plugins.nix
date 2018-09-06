{ stdenv, callPackage, fetchurl, fetchFromGitHub, unzip
, cmake, kodiPlain, libcec_platform, tinyxml
, steam, libusb, pcre-cpp, jsoncpp, libhdhomerun, zlib }:

with stdenv.lib;

let self = rec {

  pluginDir = "/share/kodi/addons";

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
  toKodiPlugin (stdenv.mkDerivation (rec {
    name = "kodi-plugin-${plugin}-${version}";

    dontStrip = true;

    installPhase = ''
      ${if isNull sourceDir then "" else "cd $src/$sourceDir"}
      d=$out${pluginDir}/${namespace}
      mkdir -p $d
      sauce="."
      [ -d ${namespace} ] && sauce=${namespace}
      cp -R "$sauce/"* $d
    '';
  } // args));

  mkKodiABIPlugin = { plugin, namespace, version, extraBuildInputs ? [], ... }@args:
  toKodiPlugin (stdenv.mkDerivation (rec {
    name = "kodi-plugin-${plugin}-${version}";

    dontStrip = true;

    buildInputs = [ cmake kodiPlain kodi-platform libcec_platform ]
               ++ extraBuildInputs;

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
      homepage = https://forum.kodi.tv/showthread.php?tid=85724;
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
      homepage = https://forum.kodi.tv/showthread.php?tid=287826;
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
        "${controller}" = mkKodiPlugin rec {
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

  exodus = mkKodiPlugin rec {

    plugin = "exodus";
    namespace = "plugin.video.exodus";
    version = "3.1.13";

    src = fetchurl {
      url = "https://offshoregit.com/${plugin}/${namespace}/${namespace}-${version}.zip";
      sha256 = "1zyay7cinljxmpzngzlrr4pnk2a7z9wwfdcsk6a4p416iglyggdj";
    };

    buildInputs = [ unzip ];

    meta = {
      description = "A streaming plugin for Kodi";
      platforms = platforms.all;
      maintainers = with maintainers; [ edwtjo ];
    };
  };

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
      homepage = https://forum.kodi.tv/showthread.php?tid=258159;
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
    version = "1.3.2";
    plugin = namespace;

    src = fetchFromGitHub {
      owner = "kodi-game";
      repo = namespace;
      rev = "96171dd32899553ffe8fc775fca66e8df5ff5cf1";
      sha256 = "18m61v8z9fbh4imvzhh4g9629r9df49g2yk9ycaczirg131dhfbh";
    };

    meta = {
      description = "Binary addon for raw joystick input.";
      platforms = platforms.all;
      maintainers = with maintainers; [ edwtjo ];
    };

    extraBuildInputs = [ libusb pcre-cpp ];

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
      homepage = https://forum.kodi.tv/showthread.php?tid=67110;
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
    version = "0.9.0";
    plugin = namespace;

    src = fetchFromGitHub {
      owner = "kodi-game";
      repo = namespace;
      rev = "76f640fad4f68118f4fab6c4c3338d13daca7074";
      sha256 = "0yqlfdiiymb8z6flyhpval8w3kdc9qv3mli3jg1xn5ac485nxsxh";
    };

    extraBuildInputs = [ libusb ];

    meta = {
      description = "Binary addon for steam controller.";
      platforms = platforms.all;
      maintainers = with maintainers; [ edwtjo ];
    };

  };

  steam-launcher = mkKodiPlugin rec {

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
      homepage = https://forum.kodi.tv/showthread.php?tid=157499;
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
      homepage = https://forum.kodi.tv/showthread.php?tid=187421;
      description = "A comic book reader";
      maintainers = with maintainers; [ edwtjo ];
    };
  };

  pvr-hts = mkKodiABIPlugin rec {

    plugin = "pvr-hts";
    namespace = "pvr.hts";
    version = "3.4.16";

    src = fetchFromGitHub {
      owner = "kodi-pvr";
      repo = "pvr.hts";
      rev = "b39e4e9870d68841279cbc7d7214f3ad9b27f330";
      sha256 = "0pmlgqr4kd0gvckz77mj6v42kcx6lb23anm8jnf2fbn877snnijx";
    };

    meta = {
      homepage = https://github.com/kodi-pvr/pvr.hts;
      description = "Kodi's Tvheadend HTSP client addon";
      platforms = platforms.all;
      maintainers = with maintainers; [ cpages ];
    };

  };

  pvr-hdhomerun = mkKodiABIPlugin rec {

    plugin = "pvr-hdhomerun";
    namespace = "pvr.hdhomerun";
    version = "2.4.7";

    src = fetchFromGitHub {
      owner = "kodi-pvr";
      repo = "pvr.hdhomerun";
      rev = "60d89d16dd953d38947e8a6da2f8bb84a0f764ef";
      sha256 = "0dvdv0vk2q12nj0i5h51iaypy3i7jfsxjyxwwpxfy82y8260ragy";
    };

    meta = {
      homepage = https://github.com/kodi-pvr/pvr.hdhomerun;
      description = "Kodi's HDHomeRun PVR client addon";
      platforms = platforms.all;
      maintainers = with maintainers; [ titanous ];
    };

    extraBuildInputs = [ jsoncpp libhdhomerun ];

  };

  pvr-iptvsimple = mkKodiABIPlugin rec {

    plugin = "pvr-iptvsimple";
    namespace = "pvr.iptvsimple";
    version = "2.4.14";

    src = fetchFromGitHub {
      owner = "kodi-pvr";
      repo = "pvr.iptvsimple";
      rev = "2a649d7e21b64c4fa4a8b14c2cc139261eebc7e8";
      sha256 = "1f1im2gachrxnr3z96h5cg2c13vapgkvkdwvrbl4hxlnyp1a6jyz";
    };

    meta = {
      homepage = https://github.com/kodi-pvr/pvr.iptvsimple;
      description = "Kodi's IPTV Simple client addon";
      platforms = platforms.all;
      maintainers = with maintainers; [ ];
      license = licenses.gpl2Plus;
    };

    extraBuildInputs = [ zlib ];
  };

  osmc-skin = mkKodiPlugin rec {

    plugin = "osmc-skin";
    namespace = "skin.osmc";
    version = "17.0.4";

    src = fetchFromGitHub {
      owner = "osmc";
      repo = namespace;
      rev = "a9268937f49286bab9fb49de430b8aafd7a60a9e";
      sha256 = "1b3fm02annsq58pcfc985glrmh21rmqksdj3q8wn6gyza06jdf3v";
    };

    meta = {
      homepage = https://github.com/osmc/skin.osmc;
      description = "The default skin for OSMC";
      platforms = platforms.all;
      maintainers = with maintainers; [ worldofpeace ];
      license = licenses.cc-by-nc-sa-30;
    };
  };

}; in self
