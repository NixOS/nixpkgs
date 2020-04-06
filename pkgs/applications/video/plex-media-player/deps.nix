{ fetchurl }:

rec {
  webClientBuildId = "179-6104f84e50e175";
  webClientDesktopBuildId = "4.29.2-e50e175";
  webClientTvBuildId = "4.29.2-6104f84";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
    sha256 = "0s27r4aqmk6pmg5ggw7zaf78vxhjv49ndbx0qjary65mn6vy2dpi";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "0a2g8kr253lh1dpl0dldp9q77ywvpv9yax4srkj8w6h5vwj7qxai";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
    sha256 = "18nkk3nisfbd6y6008p4xmz0nys5ahkysyi54ly15wqd7d0cpvjd";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "1s5537mbqbjg5fcgkvicl7ry5qfcl1cmq84qd651bhddnr44r01d";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
    sha256 = "15cb3923zhs6phv5ribzlbv3smm0zv0jjq93s90mrhpnxgczqw16";
  };
}
