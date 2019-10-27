{ stdenv, fetchFromGitHub, fetchurl, pkgconfig, cmake, python3, mkDerivation
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
    webClientBuildId = "141-4af71961b12c68";
    webClientDesktopBuildId = "3.104.2-1b12c68";
    webClientTvBuildId = "4.3.0-4af7196";

    webClient = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake";
      sha256 = "0fpkd1s49dbiqqlijxbillqd71a78p8y2sc23mwp0lvcmxrg265p";
    };
    webClientDesktopHash = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1";
      sha256 = "0sb0j44lwqz9zbm98nba4x6c1jxdzvs36ynwfg527avkxxna0f8f";
    };
    webClientDesktop = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz";
      sha256 = "0dxa0ka0igfsryzda4r5clwdl47ah78nmlmgj9d5pgsvyvzjp87z";
    };
    webClientTvHash = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1";
      sha256 = "086w1bavk2aqsyhv9zi5fynk31zf61sl91r6gjrdrz656wfk5bxa";
    };
    webClientTv = fetchurl {
      url = "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz";
      sha256 = "12vbgsfnj0j2y5jd73dpi08hqsr9888sma41nvd4ydsd7qblm455";
    };
  };
in mkDerivation rec {
  pname = "plex-media-player";
  version = "2.40.0.1007";
  vsnHash = "5482132c";

  src = fetchFromGitHub {
    owner = "plexinc";
    repo = "plex-media-player";
    rev = "v${version}-${vsnHash}";
    sha256 = "0ibdh5g8x32iy74q97jfsmxd08wnyrzs3gfiwjfgc10vaa1qdhli";
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
