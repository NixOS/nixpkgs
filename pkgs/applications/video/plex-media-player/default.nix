{ stdenv, fetchFromGitHub, fetchurl, pkgconfig, cmake, python3, mkDerivation
, libX11, libXrandr, qtbase, qtwebchannel, qtwebengine, qtx11extras
, libvdpau, SDL2, mpv, libGL }:
let
  # During compilation, a CMake bundle is downloaded from `artifacts.plex.tv`,
  # which then downloads a handful of web client-related files. To enable
  # sandboxed builds, we manually download them and save them so these files
  # are fetched ahead-of-time instead of during the CMake build. To update
  # plex-media-player use the update.sh script, so the versions and hashes
  # for these files are are also updated!
  depSrcs = import ./deps.nix { inherit fetchurl; };
in mkDerivation rec {
  pname = "plex-media-player";
  version = "2.49.0.1041";
  vsnHash = "bf8608f7";

  src = fetchFromGitHub {
    owner = "plexinc";
    repo = "plex-media-player";
    rev = "v${version}-${vsnHash}";
    sha256 = "1xsh0jxa59bvl9j8vqfi61r25x3c71xzjxdaawjxgkxl5cs6ysxz";
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

  passthru.updateScript = ./update.sh;

  meta = with stdenv.lib; {
    description = "Streaming media player for Plex";
    license = licenses.gpl2;
    maintainers = with maintainers; [ kylewlacy ];
    homepage = https://plex.tv;
  };
}
