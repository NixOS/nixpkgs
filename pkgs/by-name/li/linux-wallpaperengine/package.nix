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
  makeWrapper,
}:
let
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
  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  arch = selectSystem {
    aarch64-linux = "arm64";
    x86_64-linux = "x64";
  };
  cef-bin-name = "cef_binary_120.1.10+g3ce3184+chromium-120.0.6099.129_linux${arch}";
  cef-bin = stdenv.mkDerivation {
    pname = "cef-bin";
    version = "120.0.6099.129";

    src = fetchzip {
      url = "https://cef-builds.spotifycdn.com/${
        builtins.replaceStrings [ "+" ] [ "%2B" ] cef-bin-name
      }.tar.bz2";
      hash = selectSystem {
        aarch64-linux = "sha256-2mOh3GWdx0qxsLRKVYXOJnVY0eqz6B3z9/B9A9Xfs/A=";
        x86_64-linux = "sha256-FFkFMMkTSseLZIDzESFl8+h7wRhv5QGi1Uy5MViYpX8=";
      };
    };

    installPhase = ''
      runHook preInstall

      cp -r . $out
      chmod +w -R $out
      patchelf $out/${buildType}/libcef.so --set-rpath "${rpath}" --add-needed libudev.so
      patchelf $out/${buildType}/libGLESv2.so --set-rpath "${rpath}" --add-needed libGL.so.1
      patchelf $out/${buildType}/chrome-sandbox --set-interpreter $(cat $NIX_BINTOOLS/nix-support/dynamic-linker)
      sed 's/-O0/-O2/' -i $out/cmake/cef_variables.cmake

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
    };
  };
in
stdenv.mkDerivation rec {
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
    makeWrapper
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
    "-DCEF_ROOT=${cef-bin}"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/linux-wallpaperengine"
  ];

  preFixup = ''
    patchelf --set-rpath "${lib.makeLibraryPath buildInputs}:${cef-bin}" $out/linux-wallpaperengine/linux-wallpaperengine
    chmod 755 $out/linux-wallpaperengine/linux-wallpaperengine
    mkdir $out/bin
    makeWrapper $out/linux-wallpaperengine/linux-wallpaperengine $out/bin/linux-wallpaperengine
  '';

  meta = {
    description = "Wallpaper Engine backgrounds for Linux";
    homepage = "https://github.com/Almamu/linux-wallpaperengine";
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "linux-wallpaperengine";
    maintainers = with lib.maintainers; [ aucub ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
