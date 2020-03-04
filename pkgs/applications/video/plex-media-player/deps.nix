{ fetchurl }:

rec {
  webClientBuildId = "171-f635f96564f6ac";
  webClientDesktopBuildId = "4.27.0-564f6ac";
  webClientTvBuildId = "4.27.1-f635f96";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "0fdmmf3y8d0zx9lw6l3llwryz3wcb8v72zrwzv0s1mn0yd2znayl";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "0dwkizsz9r4h6dlq3qcshqv1anc2h3yd5g5d7hc9dxd37wyjzsag";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "1an257wm1rb777xyp8sa6ghrjzam6hfahqqskj4inljggymvxkxs";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "0220mw0r1s4ay8inwvl0bagjv0iddlbm8mv4yaw124grrclhk5yy";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "1mz83rbnwncxm178krvbdd8andiba3gfmaajy2gj4api7z97l7ki";
  };
}
