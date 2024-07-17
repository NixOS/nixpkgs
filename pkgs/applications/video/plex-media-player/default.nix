{
  lib,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  cmake,
  python3,
  mkDerivation,
  libX11,
  libXrandr,
  qtbase,
  qtwebchannel,
  qtwebengine,
  qtx11extras,
  libvdpau,
  SDL2,
  mpv,
  libGL,
}:
let
  # During compilation, a CMake bundle is downloaded from `artifacts.plex.tv`,
  # which then downloads a handful of web client-related files. To enable
  # sandboxed builds, we manually download them and save them so these files
  # are fetched ahead-of-time instead of during the CMake build. To update
  # plex-media-player use the update.sh script, so the versions and hashes
  # for these files are are also updated!
  depSrcs = import ./deps.nix { inherit fetchurl; };
in
mkDerivation rec {
  pname = "plex-media-player";
  version = "2.58.1";
  vsnHash = "ae73e074";

  src = fetchFromGitHub {
    owner = "plexinc";
    repo = "plex-media-player";
    rev = "v${version}-${vsnHash}";
    sha256 = "1q20fdp5d0blb0q6p2357bwdc2g65cadkgdp4w533ij2nyaxydjd";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    python3
  ];
  buildInputs = [
    libX11
    libXrandr
    qtbase
    qtwebchannel
    qtwebengine
    qtx11extras
    libvdpau
    SDL2
    mpv
    libGL
  ];

  preConfigure = with depSrcs; ''
    mkdir -p build/dependencies
    ln -s ${webClient} build/dependencies/buildid-${webClientBuildId}.cmake
    ln -s ${webClientDesktopHash} build/dependencies/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1
    ln -s ${webClientDesktop} build/dependencies/web-client-desktop-${webClientDesktopBuildId}.tar.xz
    ln -s ${webClientTvHash} build/dependencies/web-client-tv-${webClientTvBuildId}.tar.xz.sha1
    ln -s ${webClientTv} build/dependencies/web-client-tv-${webClientTvBuildId}.tar.xz
  '';

  cmakeBuildType = "RelWithDebInfo";

  cmakeFlags = [ "-DQTROOT=${qtbase}" ];

  # plexmediaplayer currently segfaults under wayland
  qtWrapperArgs = [
    "--set"
    "QT_QPA_PLATFORM"
    "xcb"
  ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Streaming media player for Plex";
    license = licenses.gpl2;
    maintainers = with maintainers; [ b4dm4n ];
    homepage = "https://plex.tv";
    mainProgram = "plexmediaplayer";
  };
}
