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
    webClientBuildId = "85-88b3ac67015f76";
    webClientDesktopBuildId = "3.77.2-7015f76";
    webClientTvBuildId = "3.78.0-88b3ac6";

    webClient = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
      sha256 = "0j7i4yr95ljw9cwyaygld41j7yvndj3dza3cbydv4x8mh2hn05v1";
    };
    webClientDesktopHash = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
      sha256 = "106kx9ahz7jgskpjraff2g235n1whwvf18yw0nmp5dwr9ys9h8jp";
    };
    webClientDesktop = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
      sha256 = "0h23h3fd3w43glvnhrg9qiajs0ql490kb00g3i4cpi29hy1ky45r";
    };
    webClientTvHash = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
      sha256 = "05zk2zpmcdf276ys5zyirsmvhvyvz99fa6hlgymma8ql6w67133r";
    };
    webClientTv = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
      sha256 = "1cflpgaf4kyj6ccqa11j28rkp8s7zlbnid7s00m5n2c907dihmw2";
    };
  };
in stdenv.mkDerivation rec {
  name = "plex-media-player-${version}";
  version = "2.23.0.920";
  vsnHash = "5bc1a2e5";

  src = fetchFromGitHub {
    owner = "plexinc";
    repo = "plex-media-player";
    rev = "v${version}-${vsnHash}";
    sha256 = "1jzlyj32gr3ar89qnk8slazrbchqkjfx9dchzkzfvpi6742v9igm";
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
