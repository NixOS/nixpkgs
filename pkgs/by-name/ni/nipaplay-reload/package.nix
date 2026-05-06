{
  lib,
  lua,
  fetchFromGitHub,
  flutter,
  pkg-config,
  cmake,
  ninja,
  clang,
  gtk3,
  glib,
  mpv,
  mdk-sdk,
  keybinder3,
  libplacebo,
  libunwind,
  shaderc,
  lcms2,
  libdovi,
  libdvdnav,
  libdvdread,
  libdvdcss,
  libbluray,
  mujs,
  mimalloc,
  ffmpeg,
  libass,
  pango,
  gdk-pixbuf,
  alsa-lib,
  libsecret,
  gsettings-desktop-schemas,
  libsoup_3,
  webkitgtk_4_1,
  xorg,
  at-spi2-core,
  dbus,
  wrapGAppsHook4,
  makeWrapper,
  rubberband,
  libuchardet,
  zimg,
  openal,
  pipewire,
  libpulseaudio,
  libcaca,
  libdrm,
  libepoxy,
  libglvnd,
  libdisplay-info,
  libgbm,
  libxscrnsaver,
  libayatana-appindicator,
  libxpresent,
  nv-codec-headers,
  libva,
  libvdpau,
  sqlite,
  ...
}:

flutter.buildFlutterApplication rec {
  pname = "nipaplay-reload";
  version = "1.8.11";

  src = fetchFromGitHub {
    owner = "MCDFsteve";
    repo = "NipaPlay-Reload";
    rev = "v${version}";
    hash = "sha256-XbM0d0F+dhTRSVRNpXRYpa1A2cXvh6fvSqrcuL7q0ss=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    "media_kit" = "sha256-aBQnp2gnwu4YVa6vFvjYCAU+Rf8Ovmq+hrR+3Vfygmw=";
    "media_kit_video" = "sha256-aBQnp2gnwu4YVa6vFvjYCAU+Rf8Ovmq+hrR+3Vfygmw=";
    "media_kit_libs_android_video" = "sha256-aBQnp2gnwu4YVa6vFvjYCAU+Rf8Ovmq+hrR+3Vfygmw=";
    "media_kit_libs_ios_video" = "sha256-aBQnp2gnwu4YVa6vFvjYCAU+Rf8Ovmq+hrR+3Vfygmw=";
    "media_kit_libs_linux" = "sha256-aBQnp2gnwu4YVa6vFvjYCAU+Rf8Ovmq+hrR+3Vfygmw=";
    "media_kit_libs_macos_video" = "sha256-aBQnp2gnwu4YVa6vFvjYCAU+Rf8Ovmq+hrR+3Vfygmw=";
    "media_kit_libs_video" = "sha256-aBQnp2gnwu4YVa6vFvjYCAU+Rf8Ovmq+hrR+3Vfygmw=";
    "media_kit_libs_windows_video" = "sha256-aBQnp2gnwu4YVa6vFvjYCAU+Rf8Ovmq+hrR+3Vfygmw=";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    clang
    wrapGAppsHook4
    makeWrapper
  ];

  buildInputs = [
    gtk3
    glib
    mpv
    mdk-sdk
    keybinder3
    libunwind
    shaderc
    lcms2
    libplacebo
    libdovi
    libdvdnav
    libdvdread
    libdvdcss
    libbluray
    mujs
    mimalloc
    ffmpeg
    libass
    pango
    gdk-pixbuf
    alsa-lib
    libsecret
    libsoup_3
    webkitgtk_4_1
    xorg.libX11
    at-spi2-core
    dbus
    lua
    rubberband
    libuchardet
    zimg
    openal
    pipewire
    libpulseaudio
    libcaca
    libdrm
    libepoxy
    libglvnd
    libdisplay-info
    libgbm
    libxscrnsaver
    libayatana-appindicator
    libxpresent
    nv-codec-headers
    libva
    libvdpau
    sqlite
    gsettings-desktop-schemas
  ];

  preBuild = ''
    mkdir -p assets/web
  '';

  postInstall = ''
    install -Dm644 assets/linux/io.github.MCDFsteve.NipaPlay-Reload.desktop \
      $out/share/applications/io.github.MCDFsteve.NipaPlay-Reload.desktop
    install -Dm644 assets/images/logo512.png \
      $out/share/icons/hicolor/512x512/apps/io.github.MCDFsteve.NipaPlay-Reload.png

    # Create a wrapper script for the executable with library paths
    makeWrapper $out/app/nipaplay-reload/NipaPlay $out/bin/nipaplay-reload \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          mpv
          ffmpeg
          libass
          webkitgtk_4_1
        ]
      }

    substituteInPlace $out/share/applications/io.github.MCDFsteve.NipaPlay-Reload.desktop \
      --replace "Exec=/opt/nipaplay/nipaplay" "Exec=nipaplay-reload"
  '';

  meta = with lib; {
    description = "A modern, cross-platform local video player that supports bullet comments and multiple subtitle formats.";
    homepage = "https://github.com/MCDFsteve/NipaPlay-Reload";
    license = licenses.mit;
    mainProgram = "nipaplay-reload";
    platforms = [
      "x86_64-linux"
    ];
    maintainers = [ ];
  };
}
