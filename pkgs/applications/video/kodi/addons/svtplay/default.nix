{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
}:
buildKodiAddon rec {
  pname = "svtplay";
  namespace = "plugin.video.svtplay";
  version = "5.1.21";

  src = fetchFromGitHub {
    owner = "nilzen";
    repo = "xbmc-" + pname;
    rev = "v${version}";
    sha256 = "sha256-CZtBUqFaKtMmKcpfBQp0Mb8sVvpCTkqcpfdYe41YSJs=";
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
    teams = [ teams.kodi ];

    broken = true; # no release for kodi 21
  };
}
