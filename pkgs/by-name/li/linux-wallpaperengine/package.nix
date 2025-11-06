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
  glew,
  glfw,
  glm,
  gmp,
  kissfftFloat,
  libXau,
  libXdmcp,
  libXpm,
  libXrandr,
  libXxf86vm,
  libdecor,
  libffi,
  libglut,
  libpng,
  libpulseaudio,
  lz4,
  mpv,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zlib,
  nix-update-script,
}:

let
  cef = cef-binary.overrideAttrs (oldAttrs: {
    version = "135.0.17"; # follow upstream. https://github.com/Almamu/linux-wallpaperengine/blob/b39f12757908eda9f4c1039613b914606568bb84/CMakeLists.txt#L47
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
  version = "0-unstable-2025-09-19";

  src = fetchFromGitHub {
    owner = "Almamu";
    repo = "linux-wallpaperengine";
    rev = "b39f12757908eda9f4c1039613b914606568bb84";
    fetchSubmodules = true;
    hash = "sha256-Lm4BixK+PBCN/I+ecoYfoD96zS9UysEDOfponFy3SDU=";
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
    glew
    glfw
    glm
    gmp
    kissfftFloat
    libXau
    libXdmcp
    libXpm
    libXrandr
    libXxf86vm
    libdecor
    libffi
    libglut
    libpng
    libpulseaudio
    lz4
    mpv
    wayland
    wayland-protocols
    wayland-scanner
    zlib
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=${cef.buildType}"
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
