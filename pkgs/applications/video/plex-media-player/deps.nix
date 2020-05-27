{ fetchurl }:

rec {
  webClientBuildId = "180-afec74de50e175";
  webClientDesktopBuildId = "4.29.2-e50e175";
  webClientTvBuildId = "4.29.3-afec74d";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "0rabrg3lk9vgpswk8npa54hzqf2v8ghqqnysxpwn12wrp1pc2rr9";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "02b5yq4yc411qlg2dkw5j9lrr3cn2y4d27sin0skf6qza180473g";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "0l3xv48kr2rx878a40zrgwif2ga2ikv6fdcbq9pylycnmm41pxmh";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "0wq115y2xrgwqrzr43nhkq8ba237z20yfp426ki2kdypsq8fjqka";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "1wax1qslm226l2w53m2fnl849jw349qhg3rjghx7vip5pmb43vw9";
  };
}
