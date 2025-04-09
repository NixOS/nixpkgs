{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ffmpeg,
  libglut,
  glew,
  glfw,
  glm,
  libGL,
  libpulseaudio,
  libX11,
  libXau,
  libXdmcp,
  libXext,
  libXpm,
  libXrandr,
  libXxf86vm,
  lz4,
  mpv,
  pkg-config,
  SDL2,
  SDL2_mixer,
  zlib,
  fetchzip,
  wayland,
  wayland-protocols,
  egl-wayland,
  libffi,
  wayland-scanner,
  glib,
  nss,
  nspr,
  atk,
  at-spi2-atk,
  libdrm,
  expat,
  libxcb,
  libxkbcommon,
  libXcomposite,
  libXdamage,
  libXfixes,
  libgbm,
  gtk3,
  pango,
  cairo,
  alsa-lib,
  dbus,
  at-spi2-core,
  cups,
  libxshmfence,
  udev,
  systemd,
  libdecor,
  autoPatchelfHook,
}:

let
  gl_rpath = lib.makeLibraryPath [ stdenv.cc.cc ];

  rpath = lib.makeLibraryPath [
    glib
    nss
    nspr
    atk
    at-spi2-atk
    libdrm
    libGL
    expat
    libxcb
    libxkbcommon
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libgbm
    gtk3
    pango
    cairo
    alsa-lib
    dbus
    at-spi2-core
    cups
    libxshmfence
    udev
    systemd
  ];

  buildType = "Release";

  libcef = stdenv.mkDerivation (finalAttrs: {
    pname = "cef-binary";
    version = "120.1.10";
    gitRevision = "3ce3184";
    chromiumVersion = "120.0.6099.129";

    src =
      let
        selectSystem =
          attrs:
          attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
        arch = selectSystem {
          aarch64-linux = "arm64";
          x86_64-linux = "x64";
        };
      in
      fetchzip {
        url = "https://cef-builds.spotifycdn.com/cef_binary_${finalAttrs.version}+g${finalAttrs.gitRevision}+chromium-${finalAttrs.chromiumVersion}_linux${arch}_minimal.tar.bz2";
        hash = selectSystem {
          aarch64-linux = "sha256-2mOh3GWdx0qxsLRKVYXOJnVY0eqz6B3z9/B9A9Xfs/A=";
          x86_64-linux = "sha256-FFkFMMkTSseLZIDzESFl8+h7wRhv5QGi1Uy5MViYpX8=";
        };
      };

    nativeBuildInputs = [ autoPatchelfHook ];

    installPhase = ''
      runHook preInstall

      cp --recursive --no-preserve=mode . $out
      patchelf --set-rpath "${rpath}" $out/${buildType}/libcef.so
      patchelf --set-rpath "${gl_rpath}" $out/${buildType}/libEGL.so
      patchelf --set-rpath "${gl_rpath}" $out/${buildType}/libGLESv2.so
      patchelf --set-rpath "${gl_rpath}" $out/${buildType}/libvk_swiftshader.so
      patchelf --set-rpath "${gl_rpath}" $out/${buildType}/libvulkan.so.1

      runHook postInstall
    '';

    meta = {
      description = "Simple framework for embedding Chromium-based browsers in other applications";
      homepage = "https://cef-builds.spotifycdn.com/index.html";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.bsd3;
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      hydraPlatforms = [ "x86_64-linux" ]; # Hydra "aarch64-linux" fails with "Output limit exceeded"
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "linux-wallpaperengine";
  version = "0-unstable-2024-11-08";

  src = fetchFromGitHub {
    owner = "Almamu";
    repo = "linux-wallpaperengine";
    rev = "4a063d0b84d331a0086b3f4605358ee177328d41";
    hash = "sha256-IRTGFxHPRRRSg0J07pq8fpo1XbMT4aZC+wMVimZlH/Y=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    autoPatchelfHook
  ];

  buildInputs = [
    libdecor
    ffmpeg
    libglut
    glew
    glfw
    glm
    libpulseaudio
    libXau
    SDL2_mixer
    libXdmcp
    libXpm
    libXxf86vm
    mpv
    lz4
    SDL2
    zlib
    wayland
    wayland-protocols
    egl-wayland
    libffi
    wayland-scanner
    libXrandr
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=${buildType}"
    "-DCEF_ROOT=${libcef}"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/app/linux-wallpaperengine"
  ];

  preFixup = ''
    chmod 755 $out/app/linux-wallpaperengine/linux-wallpaperengine
    patchelf --set-rpath "${lib.makeLibraryPath finalAttrs.buildInputs}:${libcef}" $out/app/linux-wallpaperengine/linux-wallpaperengine
    mkdir $out/bin
    ln -s $out/app/linux-wallpaperengine/linux-wallpaperengine $out/bin/linux-wallpaperengine
  '';

  meta = {
    description = "Wallpaper Engine backgrounds for Linux";
    homepage = "https://github.com/Almamu/linux-wallpaperengine";
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "linux-wallpaperengine";
    maintainers = with lib.maintainers; [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    hydraPlatforms = [ "x86_64-linux" ]; # Hydra "aarch64-linux" fails with "Output limit exceeded"
  };
})
