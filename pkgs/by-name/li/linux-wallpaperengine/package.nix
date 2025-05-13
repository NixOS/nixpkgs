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
  python3,
  libpng,
  fftw,
  file,
  kissfftFloat,
}:

let
  cef = cef-binary.overrideAttrs (oldAttrs: {
    version = "135.0.17";
    __intentionallyOverridingVersion = true; # `cef-binary` uses the overridden `srcHash` values in its source FOD
    gitRevision = "cbc1c5b";
    chromiumVersion = "135.0.7049.52";

    srcHash =
      {
        aarch64-linux = "sha256-LK5JvtcmuwCavK7LnWmMF2UDpM5iIZOmsuZS/t9koDs=";
        x86_64-linux = "sha256-JKwZgOYr57GuosM31r1Lx3DczYs35HxtuUs5fxPsTcY=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "linux-wallpaperengine";
  version = "0-unstable-2025-05-15";

  src = fetchFromGitHub {
    owner = "Almamu";
    repo = "linux-wallpaperengine";
    rev = "3c334aac29998d1812d1dfff51270683596f310c";
    hash = "sha256-HDP/BLhPgWCtziTVei54Vc+7qxX4aYaNXtyYXpWVTLk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    autoPatchelfHook
    python3
    file
  ];

  buildInputs = [
    libpng
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
    fftw
    kissfftFloat
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=${cef.buildType}"
    "-DCEF_ROOT=${cef}"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/app/linux-wallpaperengine"
  ];

  postInstall = ''
    rm -rf $out/bin $out/lib $out/include
    chmod 755 $out/app/linux-wallpaperengine/linux-wallpaperengine
    mkdir $out/bin
    ln -s $out/app/linux-wallpaperengine/linux-wallpaperengine $out/bin/linux-wallpaperengine
  '';

  preFixup = ''
    find $out/app/linux-wallpaperengine -type f -exec file {} \; | grep 'ELF' | cut -d: -f1 | while read -r elf_file; do
      patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$elf_file"
    done
    patchelf --set-rpath "${lib.makeLibraryPath finalAttrs.buildInputs}:$out/app/linux-wallpaperengine" $out/app/linux-wallpaperengine/linux-wallpaperengine
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
