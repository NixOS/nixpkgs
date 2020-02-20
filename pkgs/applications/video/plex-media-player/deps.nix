{ fetchurl }:

rec {
  webClientBuildId = "168-8a312e779b9a92";
  webClientDesktopBuildId = "4.24.1-79b9a92";
  webClientTvBuildId = "4.25.1-8a312e7";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "0ji5pz5qhmspifzaxj8wd1xzr6gqbb09i6r548agpsc9s58myn09";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "0sxaci93pbsfmddg5s4j8dz9r5xjf3dnxch3jnqlrqs5ylm62ndn";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "18nhjy4g6sr8qd8nygmp2gz0jdr8hqman5pa70flws614pj3qzb4";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "1fvp336rg37g78p3qgm8yyllpvlscfh71ymriv8zv06k1zx77j52";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "0dh3zghbqk9jk8sl5jmi5ih1qi4lbv8vjp41xi1xd7wjy7v1mk3v";
  };
}
