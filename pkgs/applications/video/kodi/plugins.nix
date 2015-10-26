{ stdenv, fetchFromGitHub, kodi }:

let

  pluginDir = "/lib/kodi/plugin";

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
      owner = "Angelscry";
      repo = namespace;
      rev = "bb380b6e8b664246a791f553ddc856cbc60dae1f";
      sha256 = "0g4kk68zjl5rf6mll4g4cywq70s267471dp5r1qp3bpfpzkn0vf2";
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
    version = "4.0.1";

    src = fetchFromGitHub {
      owner = "lambda81";
      repo = "lambda-addons";
      rev = "34af083980598177684eeb6e1e73da336b84575a";
      sha256 = "1fh3j4ymkrx9flpvnlyjp1q4avfmjv5a6yfwl3cmqnslkkp6kn9n";
    };

    meta = with stdenv.lib; {
      homepage = "http://forums.tvaddons.ag/forums/148-lambda-s-kodi-addons";
      description = "The origins of streaming";
      platforms = platforms.all;
      maintainers = with maintainers; [ edwtjo ];
    };

  };

  svtplay = mkKodiPlugin rec {

    plugin = "svtplay";
    namespace = "plugin.video.svtplay";
    version = "4.0.15";

    src = fetchFromGitHub {
      owner = "nilzen";
      repo = "xbmc-" + plugin;
      rev = "3b926898b7007827b469ecb1c27ede4238fd26f6";
      sha256 = "1bx2c3z8rbkk75hykpmls956hfkwvsm4d8gvlrh53s8zimlwgv7k";
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

}
