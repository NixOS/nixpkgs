{ stdenv
, lib
, fetchzip
, SDL2
, alsa-lib
, cmake
, coreutils
, extra-cmake-modules
, faudio
, freetype
, hicolor-icon-theme
, jack2
, libevdev
, libpng
, openal
, pkg-config
, qt5
, rtmidi
, soundfont-fluid
, vulkan-tools
, wayland
, withALSA ? true }:

stdenv.mkDerivation rec {
  pname = "86Box";
  version = "3.11";

  src = fetchzip {
    url = "https://github.com/86Box/86Box/archive/refs/tags/v${version}.tar.gz";
    stripRoot = false;
    sha256 = "HwL1A5y63wJvCf+8dq84dGC+y6417DnbsGUldI9AMJk=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config qt5.wrapQtAppsHook];
  qtWrapperArgs = [ ''--prefix PATH : "${runtimeLibs}"'' ];

  buildInputs = [ coreutils SDL2 openal freetype rtmidi qt5.qtbase qt5.qttools qt5.qtwayland libevdev wayland jack2 vulkan-tools faudio libpng ]
    ++ lib.optional withALSA alsa-lib;

  dontUseCmakeConfigure = true;

  runtimeLibs = lib.makeLibraryPath [ qt5.qtwayland hicolor-icon-theme soundfont-fluid];

  preConfigure = ''
    cmake -B /build/source/86Box-${version}/build -S /build/source/86Box-${version} -D CMAKE_TOOLCHAIN_FILE=/build/source/86Box-${version}/cmake/flags-gcc-x86_64.cmake
    cd /build/source/86Box-${version}/build
  '';

  installPhase = ''
    runHook preInstall;
    for i in 48x48 64x64 72x72 96x96 128x128 192x192 256x256 512x512; do
      install -Dm644 "/build/source/86Box-${version}/src/unix/assets/$i/net.86box.86Box.png" -t "$out/share/icons/hicolor/$i/apps"
    done
    install -Dm644 /build/source/86Box-${version}/src/unix/assets/net.86box.86Box.desktop -t $out/share/applications/
    install -Dm755 /build/source/86Box-${version}/build/src/86Box -t $out/bin/
    runHook postInstall;
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${runtimeLibs}" )
    substituteInPlace $out/share/applications/net.86box.86Box.desktop \
      --replace "Exec=86Box" "Exec=$out/bin/86Box"
  '';

  meta = with lib; {
    description = "Emulator of x86-based machines based on PCem";
    homepage = "https://86box.net";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.dansbandit ];
    platforms = platforms.linux ++ platforms.windows;
  };
}

