{ fetchurl }:

rec {
  webClientBuildId = "183-045db5be50e175";
  webClientDesktopBuildId = "4.29.2-e50e175";
  webClientTvBuildId = "4.29.6-045db5b";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "1xsacy1xb8a9rfdrd7lvx7n3hd0cf2c3mgmg9wl18jvwnqxyac83";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "07spxyhrg45ppa2zjn3ri4qvi6qimlmq6wmh492r3jkrwd71rxgf";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "1zll79hpgx8fghx228li9qairfd637yf8rhvjzdgpq4dvn21fv65";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "1zzfw2g76wqrxrx9kck5q79if78z91wn3awj703kz9sgxi4bkjsk";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "1f1zvrr3c0w37gvl78blg9rgxxi64nc4iv5vd87qbysfh1vpsjz0";
  };
}
