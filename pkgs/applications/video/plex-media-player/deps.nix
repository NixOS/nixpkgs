{ fetchurl }:

rec {
  webClientBuildId = "141-4af71961b12c68";
  webClientDesktopBuildId = "3.104.2-1b12c68";
  webClientTvBuildId = "4.3.0-4af7196";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "0fpkd1s49dbiqqlijxbillqd71a78p8y2sc23mwp0lvcmxrg265p";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "0sb0j44lwqz9zbm98nba4x6c1jxdzvs36ynwfg527avkxxna0f8f";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "0dxa0ka0igfsryzda4r5clwdl47ah78nmlmgj9d5pgsvyvzjp87z";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "086w1bavk2aqsyhv9zi5fynk31zf61sl91r6gjrdrz656wfk5bxa";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "12vbgsfnj0j2y5jd73dpi08hqsr9888sma41nvd4ydsd7qblm455";
  };
}
