{ fetchurl }:

rec {
  webClientBuildId = "153-f23008b1b12c68";
  webClientDesktopBuildId = "3.104.2-1b12c68";
  webClientTvBuildId = "4.13.1-f23008b";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "0p4d7y70czb2ynfdrp8i1v569y85aqahad1l3i0fcz154a593jx8";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "0l6l4w1bb4i2g2azvwbjwy6qxvnlypbnjlmjglmvj572y00y6dpm";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "0nk2rscj67xxv3gr10a605lj6rjr3nxwwg8169rw3sdxiahwd5w8";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "0qwk0n0wx9s35ih75l9vvxczsxjw0vcglwxlyw1himv72fp0ivqi";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "0j3v9fpp1gal8nak03prxy8j30g9bn6mp15sv4x625sd8ss01xl5";
  };
}
