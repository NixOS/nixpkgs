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
  mesa,
  gtk3,
  pango,
  cairo,
  alsa-lib,
  dbus,
  at-spi2-core,
  cups,
  libxshmfence,
  udev,
  libdecor,
  autoPatchelfHook,
}:
let
  buildType = "Release";
  platform =
    {
      "aarch64-linux" = "linuxarm64";
      "x86_64-linux" = "linux64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  cef-bin-name = "cef_binary_120.1.10+g3ce3184+chromium-120.0.6099.129_${platform}";
  cef-bin = stdenv.mkDerivation {
    name = "cef-bin";
    version = "120.0.6099.129";
    src =
      let
        hash =
          {
            "linuxarm64" = "sha256-iu8y2r1rd78fV2argulHoZJG+hPMPDKJ9ysnUyIgo5k=";
            "linux64" = "sha256-FFkFMMkTSseLZIDzESFl8+h7wRhv5QGi1Uy5MViYpX8=";
          }
          .${platform};
        urlName = builtins.replaceStrings [ "+" ] [ "%2B" ] cef-bin-name;
      in
      fetchzip {
        url = "https://cef-builds.spotifycdn.com/${urlName}.tar.bz2";
        inherit hash;
      };
    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -r ./* $out/
      chmod +w -R $out/
      patchelf $out/${buildType}/libcef.so --set-rpath "${rpath}" --add-needed libudev.so
      patchelf $out/${buildType}/libGLESv2.so --set-rpath "${rpath}" --add-needed libGL.so.1
      patchelf $out/${buildType}/chrome-sandbox --set-interpreter $(cat $NIX_BINTOOLS/nix-support/dynamic-linker)
      sed 's/-O0/-O2/' -i $out/cmake/cef_variables.cmake

      runHook postInstall
    '';
  };
  buildInputs = [
    atk
    glib
    cairo
    libdecor
    ffmpeg
    libglut
    glew
    glfw
    glm
    libGL
    libpulseaudio
    libX11
    libXau
    SDL2_mixer
    libXdmcp
    libXext
    libXrandr
    libXpm
    libXxf86vm
    mpv
    lz4
    SDL2
    nss
    nspr
    at-spi2-atk
    libdrm
    expat
    libxcb
    libxkbcommon
    libXcomposite
    libXdamage
    libXfixes
    mesa
    gtk3
    pango
    alsa-lib
    dbus
    at-spi2-core
    cups
    libxshmfence
    udev
    zlib
    wayland
    wayland-protocols
    egl-wayland
    libffi
    wayland-scanner
  ];
  rpath = lib.makeLibraryPath buildInputs;
in
stdenv.mkDerivation {
  inherit buildInputs;
  pname = "linux-wallpaperengine";
  version = "0-unstable-2024-10-13";

  src = fetchFromGitHub {
    owner = "Almamu";
    repo = "linux-wallpaperengine";
    rev = "ec60a8a57153e49e3684c864a6d809fe9601336b";
    hash = "sha256-M77Wp6tCXO2oFgfZ0+mdBT07CCYLsDDyHjeHtaDVvu8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    autoPatchelfHook
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=${buildType}"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/linux-wallpaperengine"
  ];

  preConfigure = ''
    patchShebangs .
    mkdir -p third_party/cef/
    ln -s ${cef-bin} third_party/cef/${cef-bin-name}
  '';

  preFixup = ''
    patchelf --set-rpath "${rpath}:${cef-bin}" $out/linux-wallpaperengine/linux-wallpaperengine
    mkdir $out/bin
    ln -s $out/linux-wallpaperengine/linux-wallpaperengine $out/bin/linux-wallpaperengine
    find $out -exec chmod 755 {} +
  '';

  meta = {
    description = "Wallpaper Engine backgrounds for Linux";
    homepage = "https://github.com/Almamu/linux-wallpaperengine";
    license = lib.licenses.gpl3Plus;
    mainProgram = "linux-wallpaperengine";
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
