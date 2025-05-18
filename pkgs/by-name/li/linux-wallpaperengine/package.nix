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
  libpulseaudio,
  libXau,
  libXdmcp,
  libXpm,
  libXrandr,
  libXxf86vm,
  lz4,
  mpv,
  pkg-config,
  SDL2,
  SDL2_mixer,
  zlib,
  wayland,
  wayland-protocols,
  egl-wayland,
  libffi,
  wayland-scanner,
  cef-binary,
  libdecor,
  autoPatchelfHook,
}:

let
  cef = cef-binary.overrideAttrs (oldAttrs: {
    version = "120.1.10";
    __intentionallyOverridingVersion = true; # `cef-binary` uses the overridden `srcHash` values in its source FOD
    gitRevision = "3ce3184";
    chromiumVersion = "120.0.6099.129";

    srcHash =
      {
        aarch64-linux = "sha256-l0PSW4ZeLhfEauf1bez1GoLfu9cwXZzEocDlGI9yFsQ=";
        x86_64-linux = "sha256-OdIVEy77tiYRfDWXgyceSstFqCNeZHswzkpw06LSnP0=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  });
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
    "-DCMAKE_BUILD_TYPE=${cef.buildType}"
    "-DCEF_ROOT=${cef}"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/app/linux-wallpaperengine"
  ];

  preFixup = ''
    patchelf --set-rpath "${lib.makeLibraryPath buildInputs}:${cef}" $out/app/linux-wallpaperengine/linux-wallpaperengine
    chmod 755 $out/app/linux-wallpaperengine/linux-wallpaperengine
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
}
