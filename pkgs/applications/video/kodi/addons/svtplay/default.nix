{ lib, buildKodiAddon, fetchFromGitHub }:
buildKodiAddon rec {
  pname = "svtplay";
  namespace = "plugin.video.svtplay";
  version = "5.1.12";

  src = fetchFromGitHub {
    owner = "nilzen";
    repo = "xbmc-" + pname;
    rev = "v${version}";
    sha256 = "04j1nhm7mh9chs995lz6bv1vsq5xzk7a7c0lmk4bnfv8jrfpj0w6";
  };

  meta = with lib; {
    homepage = "https://forum.kodi.tv/showthread.php?tid=67110";
    description = "Watch content from SVT Play";
    longDescription = ''
      With this addon you can stream content from SVT Play
      (svtplay.se). The plugin fetches the video URL from the SVT
      Play website and feeds it to the Kodi video player. HLS (m3u8)
      is the preferred video format by the plugin.
    '';
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    maintainers = teams.kodi.members;
  };
}
