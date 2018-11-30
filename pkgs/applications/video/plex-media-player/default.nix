{ stdenv, fetchFromGitHub, fetchurl, makeDesktopItem, pkgconfig, cmake, python3
, libX11, libXrandr, qtbase, qtwebchannel, qtwebengine, qtx11extras
, libvdpau, SDL2, mpv, libGL }:
let
  # During compilation, a CMake bundle is downloaded from `artifacts.plex.tv`,
  # which then downloads a handful of web client-related files. To enable
  # sandboxed builds, we manually download them and save them so these files
  # are fetched ahead-of-time instead of during the CMake build. Whenever
  # plex-media-player is updated, the versions for these files are changed,
  # so the build IDs (and SHAs) below will need to be updated!
  depSrcs = rec {
    webClientBuildId = "56-23317d81e49651";
    webClientDesktopBuildId = "3.57.1-1e49651";
    webClientTvBuildId = "3.60.1-23317d8";

    webClient = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
      sha256 = "1a48a65zzdx347kfnxriwkb0yjlhvn2g8jkda5pz10r3lwja0gbi";
    };
    webClientDesktopHash = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
      sha256 = "04wdgpsh33y8hyjhjrfw6ymf9g002jny7hvhld4xp33lwxhd2j5w";
    };
    webClientDesktop = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
      sha256 = "1asw9f84z9sm3w7ifnc7j631j84rgx23c6msmn2dnw48ckv3bj2z";
    };
    webClientTvHash = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
      sha256 = "0d1hsvmpwczwx442f8qdvfr8c3w84630j9qwpg2y4qm423sgdvja";
    };
    webClientTv = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
      sha256 = "1ih3l5paf1jl68b1xq3iqqmvs3m07fybz57hcz4f78v0gwq2kryq";
    };
  };
in stdenv.mkDerivation rec {
  name = "plex-media-player-${version}";
  version = "2.14.1.880";
  vsnHash = "301a4b6c";

  src = fetchFromGitHub {
    owner = "plexinc";
    repo = "plex-media-player";
    rev = "v${version}-${vsnHash}";
    sha256 = "0xz41r697vl6s3qvy6jwriv3pb9cfy61j6sydvdq121x5a0jnh9a";
  };

  nativeBuildInputs = [ pkgconfig cmake python3 ];
  buildInputs = [ libX11 libXrandr qtbase qtwebchannel qtwebengine qtx11extras
                  libvdpau SDL2 mpv libGL ];

  desktopItem = makeDesktopItem {
    name = "plex-media-player";
    exec = "plexmediaplayer";
    icon = "plex-media-player";
    comment = "View your media";
    desktopName = "Plex Media Player";
    genericName = "Media Player";
    categories = "AudioVideo;Video;Player;TV;";
  };

  preConfigure = with depSrcs; ''
    mkdir -p build/dependencies
    ln -s ${webClient} build/dependencies/buildid-${webClientBuildId}.cmake
    ln -s ${webClientDesktopHash} build/dependencies/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1
    ln -s ${webClientDesktop} build/dependencies/web-client-desktop-${webClientDesktopBuildId}.tar.xz
    ln -s ${webClientTvHash} build/dependencies/web-client-tv-${webClientTvBuildId}.tar.xz.sha1
    ln -s ${webClientTv} build/dependencies/web-client-tv-${webClientTvBuildId}.tar.xz
  '';

  postInstall = ''
    mkdir -p $out/share/{applications,pixmaps}
    cp ${src}/resources/images/icon.png $out/share/pixmaps/plex-media-player.png
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=RelWithDebInfo" "-DQTROOT=${qtbase}" ];

  meta = with stdenv.lib; {
    description = "Streaming media player for Plex";
    license = licenses.gpl2;
    maintainers = with maintainers; [ kylewlacy ];
    homepage = https://plex.tv;
  };
}
