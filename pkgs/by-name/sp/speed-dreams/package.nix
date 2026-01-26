{
  lib,
  stdenv,
  libGLU,
  libGL,
  libglut,
  libX11,
  plib,
  openal,
  freealut,
  libXrandr,
  xorgproto,
  libXext,
  libSM,
  libICE,
  libXi,
  libXt,
  libXrender,
  libXxf86vm,
  openscenegraph,
  expat,
  libpng12,
  zlib,
  bash,
  SDL2,
  SDL2_mixer,
  enet,
  libjpeg,
  cmake,
  pkg-config,
  libvorbis,
  curl,
  fetchgit,
  cjson,
  minizip,
  rhash,
  copyDesktopItems,
  makeWrapper,
}:

let
  glLibs = lib.optionals stdenv.isLinux [
    libGL
    libGLU
    libglut
  ];
  runtimeLibs = glLibs ++ [
    libX11
    plib
    openal
    freealut
    libXrandr
    libXext
    libSM
    libICE
    libXi
    libXt
    libXrender
    libXxf86vm
    openscenegraph
    expat
    libpng12
    zlib
    SDL2
    SDL2_mixer
    enet
    libjpeg
    libvorbis
    curl
    cjson
    minizip
    rhash
    stdenv.cc.cc.lib
  ];
  runtimeLibPath = lib.makeLibraryPath runtimeLibs;
  libPathVar = if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
in
stdenv.mkDerivation (finalAttrs: {
  version = "2.4.2";
  pname = "speed-dreams";

  src = fetchgit {
    url = "https://forge.a-lec.org/speed-dreams/speed-dreams-code.git";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ZY/0tf0wFbepEUNqpaBA4qgkWDij/joqPtbiF/48oN4=";
    fetchSubmodules = true;
  };
  NIX_CFLAGS_COMPILE = "-I${finalAttrs.src}/src/libs/tgf -I${finalAttrs.src}/src/libs/tgfdata -I${finalAttrs.src}/src/interfaces -I${finalAttrs.src}/src/libs/math -I${finalAttrs.src}/src/libs/portability";

  patches = [
    ./darwin-gl-compat.patch
  ];

  postInstall = ''
    substituteInPlace "$out/share/applications/speed-dreams.desktop" \
      --replace-fail "Exec=$out/games/speed-dreams-2" "Exec=$out/bin/speed-dreams"
    ${lib.optionalString stdenv.isLinux ''
      # Symlink for desktop icon
      mkdir -p $out/share/pixmaps/
      ln -s "$out/share/games/speed-dreams-2/data/icons/icon.png" "$out/share/pixmaps/speed-dreams-2.png"
      substituteInPlace "$out/share/applications/speed-dreams.desktop" \
        --replace-fail "Icon=/build/speed-dreams-code/speed-dreams-data/data/data/icons/icon.png" "Icon=$out/share/pixmaps/speed-dreams-2.png"
    ''}
  '';

  postFixup = ''
    mkdir -p "$out/bin"
    makeWrapperArgs=(
      --prefix ${libPathVar} : "$out/lib/games/speed-dreams-2/lib:$out/lib:${runtimeLibPath}"
    )
    ${lib.optionalString stdenv.isLinux "makeWrapperArgs+=(--set SDL_VIDEODRIVER x11)"}
    makeWrapper "$out/games/speed-dreams-2" "$out/bin/speed-dreams" "''${makeWrapperArgs[@]}"
  '';

  # RPATH of binary /nix/store/.../lib64/games/speed-dreams-2/drivers/shadow_sc/shadow_sc.so contains a forbidden reference to /build/
  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    libpng12
    libX11
    plib
    openal
    freealut
    libXrandr
    xorgproto
    libXext
    libSM
    libICE
    libXi
    libXt
    libXrender
    libXxf86vm
    zlib
    bash
    expat
    SDL2
    SDL2_mixer
    enet
    libjpeg
    openscenegraph
    libvorbis
    curl
    cjson
    minizip
    rhash
  ]
  ++ lib.optionals stdenv.isLinux [
    libGL
    libGLU
    libglut
  ];

  meta = {
    description = "Car racing game - TORCS fork with more experimental approach";
    homepage = "https://www.speed-dreams.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      raskin
      mio
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "speed-dreams";
  };
})
