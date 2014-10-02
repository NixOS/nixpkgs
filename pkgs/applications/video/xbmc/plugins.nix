{ stdenv, fetchFromGitHub, xbmc }:

let

  pluginDir = "/lib/xbmc/plugin";

  mkXBMCPlugin = { plugin, namespace, version, src, meta, ... }:
  stdenv.lib.makeOverridable stdenv.mkDerivation rec {
    inherit src meta;
    name = "xbmc-plugin-${plugin}-${version}";
    passthru = {
      xbmcPlugin = pluginDir;
      namespace = namespace;
    };
    dontStrip = true;
    installPhase = ''
      d=$out${pluginDir}/${namespace}
      mkdir -p $d
      cp -R $src/* $d
    '';
  };

in
{

  advanced-launcher = mkXBMCPlugin rec {

    plugin = "advanced-launcher";
    namespace = "plugin.program.advanced.launcher";
    version = "2.5.7";

    src = fetchFromGitHub {
      owner = "Angelscry";
      repo = namespace;
      rev = "f6f7980dc66d041e1635bb012d79aa8b3a8790ba";
      sha256 = "0wk41lpd6fw504q5x1h76hc99vw4jg4vq44bh7m21ism85ds0r47";
    };

    meta = with stdenv.lib; {
      homepage = "http://forum.xbmc.org/showthread.php?tid=85724";
      description = "A program launcher for XBMC";
      longDescription = ''
        Advanced Launcher allows you to start any Linux, Windows and
        OS X external applications (with command line support or not)
        directly from the XBMC GUI. Advanced Launcher also give you
        the possibility to edit, download (from Internet resources)
        and manage all the meta-data (informations and images) related
        to these applications.
      '';
      platforms = platforms.all;
      maintainers = with maintainers; [ edwtjo ];
    };

  };

  svtplay = mkXBMCPlugin rec {

    plugin = "svtplay";
    namespace = "plugin.video.svtplay";
    version = "4.0.6";

    src = fetchFromGitHub {
      owner = "nilzen";
      repo = "xbmc-" + plugin;
      rev = "4f27254edbd6dc48350152832833c5b164ca58de";
      sha256 = "11r8vljpx9fxwdx20cvkb5szlaypfrn6c235jwcg61s4hmjy4kl8";
    };

    meta = with stdenv.lib; {
      homepage = "http://forum.xbmc.org/showthread.php?tid=67110";
      description = "Watch content from SVT Play";
      longDescription = ''
        With this addon you can stream content from SVT Play
        (svtplay.se). The plugin fetches the video URL from the SVT
        Play website and feeds it to the XBMC video player. HLS (m3u8)
        is the preferred video format by the plugin.
      '';
      platforms = platforms.all;
      maintainers = with maintainers; [ edwtjo ];
    };

  };

}