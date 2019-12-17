{ fetchurl }:

rec {
  webClientBuildId = "159-65a90631b12c68";
  webClientDesktopBuildId = "3.104.2-1b12c68";
  webClientTvBuildId = "4.17.1-65a9063";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "1zj5rr9naq6p7gw28j7pg50m8n6hc2bcgnk5yvnlxwki19y9fi51";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "0hb03psy60zrmlwvskmbbx1l39lwqghi2anjcc35i64n9vqxjv8y";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "11nvivs3l9shdy8gx6rgpar8il5k5cax1dzrnmgczdbhk4amfbvw";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "1yrplhn3sfyp334kh67x8vwxk6q0n1w310y876d19kb4l555s63f";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "0z62fq6726z0jlni6cnwcg09awf5m9lckq74bxc026qzzr3i1789";
  };
}
