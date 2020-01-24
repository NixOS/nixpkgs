{ fetchurl }:

rec {
  webClientBuildId = "164-39a91721b12c68";
  webClientDesktopBuildId = "3.104.2-1b12c68";
  webClientTvBuildId = "4.21.1-39a9172";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "10aw6md2yqjy862zwp3sacfi150k1zlg53w0171vbszfadlh0jsb";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "1c6z0lfxdnbf9sghl9517czndmq1srzkxppxg6092y0gb97qhv2m";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "0k748743q0m65404rsbv8hwr45jkw8z19xm55sm0pirrkn23w57c";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "17vrxp0pjk9ad7b3xw5s0q3x3wbng9l52vbhrh83dkb5maxrb04n";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "0ydk6k5fvc6bpk3i5fs3z4m2aih0wv5zbasgifwmgrqzqr23ac0k";
  };
}
