{ fetchurl }:

rec {
  webClientBuildId = "162-d8d29131b12c68";
  webClientDesktopBuildId = "3.104.2-1b12c68";
  webClientTvBuildId = "4.19.1-d8d2913";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "1lbib79g8lswh9ip3knfh0mi1fwqm03h8pdqnkd7f768wj8lspk4";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "1956w742j2hnj2b5hpy4bc3hv6zvr53xljmslcibhhqrr4v0zzkx";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "0pdzlx3s2x77nhyk929y42gqx5c19njhz22gmfdas5grkbb19qw8";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "08rrid1bs87mljp14p6ph93lcg9490llghl7sgq658rg6g2cv2js";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "0q517dw6gxgpd860iragm7ygaskiyvz26k1bhsvph27lib5a5sbx";
  };
}
