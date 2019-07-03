{ stdenv, fetchFromGitHub, fetchurl, pkgconfig, cmake, python3
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
    webClientBuildId = "129-669a5eed7ae231";
    webClientDesktopBuildId = "3.100.1-d7ae231";
    webClientTvBuildId = "3.105.0-669a5ee";

    webClient = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
      sha256 = "0gd7x0rf7sf696zd24y6pji9iam851vjjqbpm4xkqwpadwrwzhwk";
    };
    webClientDesktopHash = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
      sha256 = "136hk7p6gxxmhq1d09jfjljkv76b5h2p16s5jwf28xixkp0ab2jg";
    };
    webClientDesktop = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
      sha256 = "0yvjqar72jq58jllsp51b8ybiv6kad8w51bfzss87m1cv3qdbzpa";
    };
    webClientTvHash = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
      sha256 = "0kkw9dd0kr5n4ip1pwfs2dkfjwrph88i0dlw64dca9i885gyjvhd";
    };
    webClientTv = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
      sha256 = "0yssii01nx6ixg3mikqjn8hz34dalma0rfr8spj115xwr7aq8ixk";
    };
  };
in stdenv.mkDerivation rec {
  name = "plex-media-player-${version}";
  version = "2.36.0.988";
  vsnHash = "0150ae52";

  src = fetchFromGitHub {
    owner = "plexinc";
    repo = "plex-media-player";
    rev = "v${version}-${vsnHash}";
    sha256 = "104arb0afv3jz0bvj8ij5s7av289ms9n91b4y4077la2wd6r1bq0";
  };

  nativeBuildInputs = [ pkgconfig cmake python3 ];
  buildInputs = [ libX11 libXrandr qtbase qtwebchannel qtwebengine qtx11extras
                  libvdpau SDL2 mpv libGL ];

  preConfigure = with depSrcs; ''
    mkdir -p build/dependencies
    ln -s ${webClient} build/dependencies/buildid-${webClientBuildId}.cmake
    ln -s ${webClientDesktopHash} build/dependencies/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1
    ln -s ${webClientDesktop} build/dependencies/web-client-desktop-${webClientDesktopBuildId}.tar.xz
    ln -s ${webClientTvHash} build/dependencies/web-client-tv-${webClientTvBuildId}.tar.xz.sha1
    ln -s ${webClientTv} build/dependencies/web-client-tv-${webClientTvBuildId}.tar.xz
  '';

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=RelWithDebInfo" "-DQTROOT=${qtbase}" ];

  meta = with stdenv.lib; {
    description = "Streaming media player for Plex";
    license = licenses.gpl2;
    maintainers = with maintainers; [ kylewlacy ];
    homepage = https://plex.tv;
  };
}
