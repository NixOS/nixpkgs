{ stdenv, fetchurl, fetchFromGitHub, fetchpatch, lib
, unzip, cmake, kodi, steam, libcec_platform, tinyxml }:

let

  pluginDir = "/share/kodi/addons";

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

    buildInputs = [ cmake kodi libcec_platform tinyxml ];
  };

  mkKodiPlugin = { plugin, namespace, version, src, meta, sourceDir ? null, ... }:
  stdenv.lib.makeOverridable stdenv.mkDerivation rec {
    inherit src meta sourceDir;
    name = "kodi-plugin-${plugin}-${version}";
    passthru = {
      kodiPlugin = pluginDir;
      namespace = namespace;
    };
    dontStrip = true;
    installPhase = ''
      ${if isNull sourceDir then "" else "cd $src/$sourceDir"}
      d=$out${pluginDir}/${namespace}
      mkdir -p $d
      sauce="."
      [ -d ${namespace} ] && sauce=${namespace}
      cp -R "$sauce/"* $d
    '';
  };

in
{

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

    meta = with stdenv.lib; {
      homepage = "http://forum.kodi.tv/showthread.php?tid=85724";
      description = "A program launcher for Kodi";
      longDescription = ''
        Advanced Launcher allows you to start any Linux, Windows and
        OS X external applications (with command line support or not)
        directly from the Kodi GUI. Advanced Launcher also give you
        the possibility to edit, download (from Internet resources)
        and manage all the meta-data (informations and images) related
        to these applications.
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

    meta = with stdenv.lib; {
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

  exodus = (mkKodiPlugin rec {

    plugin = "exodus";
    namespace = "plugin.video.exodus";
    version = "3.0.5";

    src = fetchurl {
      url = "https://offshoregit.com/${plugin}/${namespace}/${namespace}-${version}.zip";
      sha256 = "0di34sp6y3v72l6gfhj7cvs1vljs9vf0d0x2giix3jk433cj01j0";
    };

    meta = with stdenv.lib; {
      description = "A streaming plugin for Kodi";
      platforms = platforms.all;
      maintainers = with maintainers; [ edwtjo ];
    };

  }).override { buildInputs = [ unzip ]; };

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
    meta = with stdenv.lib; {
      homepage = http://forum.kodi.tv/showthread.php?tid=258159;
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

  svtplay = mkKodiPlugin rec {

    plugin = "svtplay";
    namespace = "plugin.video.svtplay";
    version = "4.0.42";

    src = fetchFromGitHub {
      name = plugin + "-" + version + ".tar.gz";
      owner = "nilzen";
      repo = "xbmc-" + plugin;
      rev = "83cb52b949930a1b6d2e51a7a0faf9bd69c7fb7d";
      sha256 = "0ync2ya4lwmfn6ngg8v0z6bng45whwg280irsn4bam5ca88383iy";
    };

    meta = with stdenv.lib; {
      homepage = "http://forum.kodi.tv/showthread.php?tid=67110";
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

  steam-launcher = (mkKodiPlugin rec {

    plugin = "steam-launcher";
    namespace = "script.steam.launcher";
    version = "3.1.4";

    src = fetchFromGitHub rec {
      owner = "teeedubb";
      repo = owner + "-xbmc-repo";
      rev = "db67704c3e16bdcdd3bdfe2926c609f1f6bdc4fb";
      sha256 = "001a7zs3a4jfzj8ylxv2klc33mipmqsd5aqax7q81fbgwdlndvbm";
    };

    meta = with stdenv.lib; {
      homepage = "http://forum.kodi.tv/showthread.php?tid=157499";
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
  }).override {
    propagatedBuildinputs = [ steam ];
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

    meta = with stdenv.lib; {
      homepage = http://forum.kodi.tv/showthread.php?tid=187421;
      descritpion = "A comic book reader";
      maintainers = with maintainers; [ edwtjo ];
    };
  };

  pvr-hts = (mkKodiPlugin rec {
    plugin = "pvr-hts";
    namespace = "pvr.hts";
    version = "3.4.16";

    src = fetchFromGitHub {
      owner = "kodi-pvr";
      repo = "pvr.hts";
      rev = "b39e4e9870d68841279cbc7d7214f3ad9b27f330";
      sha256 = "0pmlgqr4kd0gvckz77mj6v42kcx6lb23anm8jnf2fbn877snnijx";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/kodi-pvr/pvr.hts;
      description = "Kodi's Tvheadend HTSP client addon";
      platforms = platforms.all;
      maintainers = with maintainers; [ cpages ];
    };
  }).override {
    buildInputs = [ cmake kodi libcec_platform kodi-platform ];

    # disables check ensuring install prefix is that of kodi
    cmakeFlags = [ "-DOVERRIDE_PATHS=1" ];

    # kodi checks for plugin .so libs existance in the addon folder (share/...)
    # and the non-wrapped kodi lib/... folder before even trying to dlopen
    # them. Symlinking .so, as setting LD_LIBRARY_PATH is of no use
    installPhase = ''
      make install
      ln -s $out/lib/addons/pvr.hts/pvr.hts.so* $out/share/kodi/addons/pvr.hts
    '';
  };
}
