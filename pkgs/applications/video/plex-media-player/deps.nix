{ fetchurl }:

rec {
  webClientBuildId = "172-17d1db2564f6ac";
  webClientDesktopBuildId = "4.27.0-564f6ac";
  webClientTvBuildId = "4.27.1-17d1db2";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "0k62gn0kc3kd9g0vqdzay8ln98l6kg7hiqhzzbnfhhn531zdh83b";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "1mnw8c8acb0ds7k9hxz85cq3flg8as4izmlxhsm7h42n00dcz3qg";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "14h9wsmrkhksvyh22rryqzvcc2dqgxhpj9xfrh0q5m43lldw2afr";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "0qsic7dv290kvwraa6b6r8ghx22wkbb2hr2b6ix3w56wwc06a1x4";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "0jpbszf7q0h482nsqlvyymjlgc2sd4qan6pf7gq3vn0yswkjdaxq";
  };
}
