{ fetchurl }:

rec {
  webClientBuildId = "176-21c9724ca0ff70";
  webClientDesktopBuildId = "4.26.1-ca0ff70";
  webClientTvBuildId = "4.29.1-21c9724";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "0l1p5s116h16qhifkcjg1h5wifyl753cndl65nz9z1f3lx5nz3l3";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "1sfmkgny5sjj0vl4lymp4pzs8v7zsszx8ild0qac7jap81c5qwhn";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "0bd7gwyrnsv8v1ld5kqb5hwxrjqmf3ziy5xh742jdp0fdvlk7c8p";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "10vchj0d21qh683vgm71mrznw0dq9rfb6166bw2nyqk8rbr73zf7";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "0amr42mnc7l54ikvq0f86ffbkkhxw29qxhbfmp3g1k66ckpz7dnd";
  };
}
