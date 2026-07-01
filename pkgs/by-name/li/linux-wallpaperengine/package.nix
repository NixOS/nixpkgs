{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  cmake,
  file,
  pkg-config,
  python3,
  SDL2,
  SDL2_mixer,
  cef-binary,
  egl-wayland,
  ffmpeg,
  fftw,
  freetype,
  glew,
  glfw,
  glm,
  gmp,
  kissfftFloat,
  libxau,
  libxdmcp,
  libxpm,
  libxrandr,
  libxxf86vm,
  libdecor,
  libffi,
  libglut,
  libpng,
  libpulseaudio,
  lz4,
  mpv,
  pulseaudio,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zlib,
  nix-update-script,
  dbus,
}:

let
  cef = cef-binary.override {
    version = "135.0.17"; # follow upstream. https://github.com/Almamu/linux-wallpaperengine/blob/b39f12757908eda9f4c1039613b914606568bb84/CMakeLists.txt#L47
    gitRevision = "cbc1c5b";
    chromiumVersion = "135.0.7049.52";

    srcHashes = {
      aarch64-linux = "sha256-LK5JvtcmuwCavK7LnWmMF2UDpM5iIZOmsuZS/t9koDs=";
      x86_64-linux = "sha256-JKwZgOYr57GuosM31r1Lx3DczYs35HxtuUs5fxPsTcY=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "linux-wallpaperengine";
  version = "0-unstable-2026-06-09";

  src = fetchFromGitHub {
    owner = "Almamu";
    repo = "linux-wallpaperengine";
    rev = "b016d7d1fdcf4e5fd2f9c9fa420a8aaa07fee02d";
    fetchSubmodules = true;
    hash = "sha256-ExWAYdSFW5plPuS3/jxTPMXIly6zVb5GojE3e37imZM=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    file
    pkg-config
    python3
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    egl-wayland
    ffmpeg
    fftw
    freetype
    glew
    glfw
    glm
    gmp
    kissfftFloat
    libxau
    libxdmcp
    libxpm
    libxrandr
    libxxf86vm
    libdecor
    libffi
    libglut
    libpng
    libpulseaudio
    lz4
    mpv
    pulseaudio
    wayland
    wayland-protocols
    wayland-scanner
    zlib
    dbus
  ];

  cmakeFlags = [
    "-DCEF_ROOT=${cef}"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/share/linux-wallpaperengine"
  ];

  postInstall = ''
    rm -rf $out/bin $out/lib $out/include
    chmod 755 $out/share/linux-wallpaperengine/linux-wallpaperengine
    mkdir $out/bin
    ln -s $out/share/linux-wallpaperengine/linux-wallpaperengine $out/bin/linux-wallpaperengine
  '';

  preFixup = ''
    find $out/share/linux-wallpaperengine -type f -exec file {} \; | grep 'ELF' | cut -d: -f1 | while read -r elf_file; do
      patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$elf_file"
    done
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Wallpaper Engine backgrounds for Linux";
    homepage = "https://github.com/Almamu/linux-wallpaperengine";
    license = lib.licenses.gpl3Plus;
    mainProgram = "linux-wallpaperengine";
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    hydraPlatforms = [ "x86_64-linux" ]; # Hydra "aarch64-linux" fails with "Output limit exceeded"
  };
})
