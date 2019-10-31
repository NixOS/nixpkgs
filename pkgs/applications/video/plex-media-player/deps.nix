{ fetchurl }:

rec {
  webClientBuildId = "151-ce86ded1b12c68";
  webClientDesktopBuildId = "3.104.2-1b12c68";
  webClientTvBuildId = "4.11.1-ce86ded";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "1pl1qfb9wdfrcsasq66gz85819x4zrknkc7655n78xllly55j28s";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "1s28lfm96jrghz2c8d4yap3dl6y1gxd0svvdnva6jjl205361a6q";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "1k1agr0332hlr5a9xdkfnqpppppwgnmvwd43slw7j5f8r6j4hfsf";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "0xm9shp04ri99fd2lahx5ijf27qhyxji7zsdkm80zwwaqzzb13xw";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "0fyk2rvn9mc2xwavmki81yp40d9gz8dd6jajjyhq7mdgsp55xw3b";
  };
}
