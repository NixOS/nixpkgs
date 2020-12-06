{ fetchurl }:

rec {
  webClientBuildId = "183-045db5be50e175";
  webClientDesktopBuildId = "4.29.2-e50e175";
  webClientTvBuildId = "4.29.6-045db5b";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "AzHlO7Z8SxQoT6++OphwDDQ47Ombnpaby0mh1YNnSvc=";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "7vUcTuN5ypFFIrBygyutEZu4MYl5WPmFureQl6HvVx8=";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "xWwXhN2N4Pvalxtm5PwZprkcFU6RIiE6fA71d2E6lP4=";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "U8u5SOxPpz8HOJKrYXlIHx0X08Flspl67hlzc57g7v8=";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "4Et9d4BO+4UParvsSJglJvb+cnp0oUP3O4MDNnLeP7g=";
  };
}
