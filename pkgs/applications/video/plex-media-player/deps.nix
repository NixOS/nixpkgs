{ fetchurl }:

rec {
  webClientBuildId = "148-aa5f46f1b12c68";
  webClientDesktopBuildId = "3.104.2-1b12c68";
  webClientTvBuildId = "4.7.1-aa5f46f";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "1g5p9avx51v1j14ddyyclxawx32m0a3k8q25rci5cbbg5a93crls";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "1ah955659szn0jd602k2487a0mk4nrabjpkqplmd6qdmgpa6hgj9";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "0zhpjlnwlgbz01cznvv3gni42qynhbvww2jmr6j2raamgxn1w5xc";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "0q26q12vvg00swdw24yyvn09144b90nr8653msqpx91x9sm5aiq4";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "0gmhk7jgm37arqnxz92qni4qrsbf0sgqgmgsvfs2gkyn1wxj3xqr";
  };
}
