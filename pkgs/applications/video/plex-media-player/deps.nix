{ fetchurl }:

rec {
  webClientBuildId = "166-78faf811b12c68";
  webClientDesktopBuildId = "3.104.2-1b12c68";
  webClientTvBuildId = "4.23.1-78faf81";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "140xl65mwa43fkjdrk77n5lp8zfk2zbqj7mjzmc2w4g0vdrrvicd";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "1832acwsxcgdnbgaylribv7nmr80kn2k6bimmvq0cwx5c6dp61z0";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "06184vza9rq6q1shsa2xclvs7f7ir56gs3yp1c8x20w8qfpszmgk";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "0c2plqjk65j6810swz76sq7nf02ja06n0761wapaz62c6s3sbwww";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "052b6lr57lmwpmb9wi41hy6795c3p5ka3yr3iizw490481pkzlzc";
  };
}
