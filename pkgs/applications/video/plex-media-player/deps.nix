{ fetchurl }:

rec {
  webClientBuildId = "144-56c0a921b12c68";
  webClientDesktopBuildId = "3.104.2-1b12c68";
  webClientTvBuildId = "4.5.1-56c0a92";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "0ivw949f6b22i7rn9nqvw0iz3cmppc9g88qlx57dhghslsgr7llc";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "04d2r6awlfzgvxxdz3qj9xd5dfnlmljasj5r6bjjv3ary41f1764";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "1mg2w7y9idhzfafz47ic0zyqzhjlr4x3kakfx4vajlsbp5894hb3";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "0mxsj8shll0d3y0wf2zvxvn69axcqjbr5zrj8rpvdvi1mnpscxrj";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "0d3szjjxlxzqmn3bxirnmzlhspckg7cl96fpwnrqhbc3m2fmbqj1";
  };
}
