{ fetchurl }:

rec {
  webClientBuildId = "149-466665d1b12c68";
  webClientDesktopBuildId = "3.104.2-1b12c68";
  webClientTvBuildId = "4.9.0-466665d";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "1ir1z543hsswsfnxchr8kbw7h9gnhbb11n3qyw2njkyxc7g7m2r8";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "02zrldnh875k8f03rsf349gsgabx8h46z3sddn4jrwwkwdpnhyr0";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "18b44rsqqd1ma4rpl2cl6vanw2s6fpnqq6yqxnq3ypxqd5lgzw3c";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "1mg04kp8w0mpmz2154q2yibl9wfy6gw7g4rvjd1ss9q3q0csy4wr";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "1infhlcrij42rzpabrcz4gpvnkcylxvivj2i9f9ial1l9nyxhgny";
  };
}
