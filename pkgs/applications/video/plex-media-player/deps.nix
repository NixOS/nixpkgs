{ fetchurl }:

rec {
  webClientBuildId = "173-17d1db2ca0ff70";
  webClientDesktopBuildId = "4.26.1-ca0ff70";
  webClientTvBuildId = "4.27.1-17d1db2";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "0dlcr37cc4rq71j5ki1q6i4rh34rvlpv1pdlnsh4g3k3br513y0f";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "1d54w82g12y1rc5didfpqr0fg1z372by5kygznz260my1cb78gk0";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "1ghv1s4mnbkk02plkfp092n59dga0kviwm9wdv95h71nx7h0ixc5";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "0pxl4jxx1yjzi6a1pipkkz4b7fqncry1y0dimf5imbk3jrb15w24";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "1w2x0fy5ayg185zpcmgphfgybrfrvrnij2z0xgab318v6c2fra0v";
  };
}
