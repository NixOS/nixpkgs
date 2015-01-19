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
      cp -R $sauce/* $d
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
    version = "2.4.1";

    src = fetchFromGitHub {
      owner = "lambda81";
      repo = "lambda-addons";
      rev = "1eb1632063e18f3f30e9fdbed2a15cf1e9c05315";
      sha256 = "1gzx0jq4gyhkpdd21a70lhww9djr5dlgyl93b4l7dhgr3hnzxccl";
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
    version = "4.0.9";

    src = fetchFromGitHub {
      owner = "nilzen";
      repo = "xbmc-" + plugin;
      rev = "29a754e49584d1ca32f0c07b87304669cf266bb0";
      sha256 = "0k7mwaknw4h1jlq7ialbzgxxpb11j8bk29dx2gimp40lvnyw4yhz";
    };

    meta = with stdenv.lib; {
      homepage = "http://forum.kodi.org/showthread.php?tid=67110";
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