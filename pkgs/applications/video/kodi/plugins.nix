{ stdenv, fetchFromGitHub, fetchpatch, cmake, kodi, steam, libcec_platform, tinyxml }:

let

  pluginDir = "/share/kodi/addons";

  kodi-platform = stdenv.mkDerivation rec {
    project = "kodi-platform";
    version = "15.2";
    name = "${project}-${version}";

    src = fetchFromGitHub {
      owner = "xbmc";
      repo = project;
      rev = "45d6ad1984fdb1dc855076ff18484dbec33939d1";
      sha256 = "1fai33mwyv5ab47b16i692g7a3vcnmxavx13xin2gh16y0qm62hi";
    };

    buildInputs = [ cmake kodi libcec_platform tinyxml ];
  };

  mkKodiPlugin = { plugin, namespace, version, src, meta, ... }:
  stdenv.lib.makeOverridable stdenv.mkDerivation rec {
    inherit src meta;
    name = "kodi-plugin-${plugin}-${version}";
    passthru = {
      kodiPlugin = pluginDir;
      namespace = namespace;
    };
    dontStrip = true;
    installPhase = ''
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

  genesis = mkKodiPlugin rec {

    plugin = "genesis";
    namespace = "plugin.video.genesis";
    version = "5.1.3";

    src = fetchFromGitHub {
      owner = "lambda81";
      repo = "lambda-addons";
      rev = "f2cd04f33af88d60e1330573bbf2ef9cee7f0a56";
      sha256 = "0z0ldckqqif9v5nhnjr5n2495cm3z9grjmrh7czl4xlnq4bvviqq";
    };

    meta = with stdenv.lib; {
      homepage = "http://forums.tvaddons.ag/forums/148-lambda-s-kodi-addons";
      description = "The origins of streaming";
      platforms = platforms.all;
      maintainers = with maintainers; [ edwtjo ];
    };

  };

  urlresolver = (mkKodiPlugin rec {

    plugin = "urlresolver";
    namespace = "script.module.urlresolver";
    version = "2.10.0";

    src = fetchFromGitHub {
      name = plugin + "-" + version + ".tar.gz";
      owner = "Eldorados";
      repo = namespace;
      rev = "72b9d978d90d54bb7a0224a1fd2407143e592984";
      sha256 = "0r5glfvgy9ri3ar9zdkvix8lalr1kfp22fap2pqp739b6k2iqir6";
    };

    meta = with stdenv.lib; {
      homepage = "https://github.com/Eldorados/urlresolver";
      description = "Resolve common video host URL's to be playable in XBMC/Kodi";
      maintainers = with maintainers; [ edwtjo ];
    };
  }).override {
    patches = [ (fetchpatch {
      url = https://github.com/Eldorados/script.module.urlresolver/pull/355.patch;
      sha256 = "0q1n2sqdjqq32202s6ifh81c9a1l5a7yfkkf170dbkiajvxglz1m";
    }) ];
  };

  salts = (mkKodiPlugin rec {

    plugin = "salts";
    namespace = "plugin.video.salts";
    version = "1.0.98";

    src = fetchFromGitHub {
      name = plugin + "-" + version + ".tar.gz";
      owner = "tknorris";
      repo = plugin;
      rev = "02cb63360ac1f60c01ec29d1da94902542f9a47a";
      sha256 = "10cy633g383m1xy6yap46aqzyz96dh62y7c5rn5nvyw8ms18089z";
    };

    meta = with stdenv.lib; {
      homepage = "https://github.com/tknorris/salts";
      description = "Stream All The Sources";
      maintainers = with maintainers; [ edwtjo ];
    };
  }).override {
    patches = [ (fetchpatch {
      url = https://github.com/tknorris/salts/pull/115.patch;
      sha256 = "157dhp049mw8lna6cg3x549jv2b9zq1vj6v94mil65q2hlw09sjd";
    }) ];
  };

  svtplay = mkKodiPlugin rec {

    plugin = "svtplay";
    namespace = "plugin.video.svtplay";
    version = "4.0.21";

    src = fetchFromGitHub {
      name = plugin + "-" + version + ".tar.gz";
      owner = "nilzen";
      repo = "xbmc-" + plugin;
      rev = "1fb099dcddc65e58ca8691d19de657321b1b1fc2";
      sha256 = "178krh8kzll7cprqwyhydb41b1jh961av875bm5yfdlplzaiynm0";
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
    version = "3.1.1";

    src = fetchFromGitHub rec {
      owner = "teeedubb";
      repo = owner + "-xbmc-repo";
      rev = "bb66db7c4927619485373699ff865a9b00e253bb";
      sha256 = "1skjkz0h6nkg04vylhl4zzavf5lba75j0qbgdhb9g7h0a98jz7s4";
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

  t0mm0-common = mkKodiPlugin rec {

    plugin = "t0mm0-common";
    namespace = "script.module.t0mm0.common";
    version = "0.0.1";

    src = fetchFromGitHub {
      name = plugin + "-" + version + ".tar.gz";
      owner = "t0mm0";
      repo = "xbmc-urlresolver";
      rev = "ab16933a996a9e77b572953c45e70900c723d6e1";
      sha256 = "1yd00md8iirizzaiqy6fv1n2snydcpqvp2f9irzfzxxi3i9asb93";
    };

    meta = with stdenv.lib; {
      homepage = "https://github.com/t0mm0/xbmc-urlresolver/";
      description = "t0mm0's common stuff";
      maintainers = with maintainers; [ edwtjo ];
    };
  };

  pvr-hts = (mkKodiPlugin rec {
    plugin = "pvr-hts";
    namespace = "pvr.hts";
    version = "2.1.18";

    src = fetchFromGitHub {
      owner = "kodi-pvr";
      repo = "pvr.hts";
      rev = "016b0b3251d6d5bffaf68baf59010e4347759c4a";
      sha256 = "03lhxipz03r516pycabqc9b89kd7wih3c2dr4p602bk64bsmpi0j";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/kodi-pvr/pvr.hts;
      description = "Kodi's Tvheadend HTSP client addon";
      platforms = platforms.all;
      maintainers = with maintainers; [ page ];
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
      ln -s $out/lib/kodi/addons/pvr.hts/pvr.hts.so $out/share/kodi/addons/pvr.hts
    '';
  };
}
