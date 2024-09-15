{
  lib,
  fetchFromGitHub,
  applyPatches,
  _2ship2harkinian,
  fetchurl,
  writeTextFile,
  stdenv,
  cmake,
  copyDesktopItems,
  imagemagick,
  lsb-release,
  makeWrapper,
  ninja,
  pkg-config,
  python3,
  libGL,
  libpng,
  libpulseaudio,
  libzip,
  nlohmann_json,
  SDL2,
  spdlog,
  tinyxml-2,
  zenity,
  makeDesktopItem,
}:

let

  # The following are either normally fetched during build time or a specific version is required

  gamecontrollerdb = fetchFromGitHub {
    owner = "mdqinc";
    repo = "SDL_GameControllerDB";
    rev = "e84a52679007c6a6346794cda1fdbcb941ac6494";
    hash = "sha256-npgsTvRQRQkgT8C1nwisJqq2m+DT9q/r/Zev2NipGcU=";
  };

  imgui' = applyPatches {
    src = fetchFromGitHub {
      owner = "ocornut";
      repo = "imgui";
      tag = "v1.90.6-docking";
      hash = "sha256-Y8lZb1cLJF48sbuxQ3vXq6GLru/WThR78pq7LlORIzc=";
    };
    patches = [
      "${_2ship2harkinian.src}/libultraship/cmake/dependencies/patches/sdl-gamepad-fix.patch"
    ];
  };

  libgfxd = fetchFromGitHub {
    owner = "glankk";
    repo = "libgfxd";
    rev = "008f73dca8ebc9151b205959b17773a19c5bd0da";
    hash = "sha256-AmHAa3/cQdh7KAMFOtz5TQpcM6FqO9SppmDpKPTjTt8=";
  };

  stb_impl = writeTextFile {
    name = "stb_impl.c";
    text = ''
      #define STB_IMAGE_IMPLEMENTATION
      #include "stb_image.h"
    '';
  };

  stb' = fetchurl {
    name = "stb_image.h";
    url = "https://raw.githubusercontent.com/nothings/stb/0bc88af4de5fb022db643c2d8e549a0927749354/stb_image.h";
    hash = "sha256-xUsVponmofMsdeLsI6+kQuPg436JS3PBl00IZ5sg3Vw=";
  };

  stormlib' = applyPatches {
    src = fetchFromGitHub {
      owner = "ladislav-zezula";
      repo = "StormLib";
      tag = "v9.25";
      hash = "sha256-HTi2FKzKCbRaP13XERUmHkJgw8IfKaRJvsK3+YxFFdc=";
    };
    patches = [
      "${_2ship2harkinian.src}/libultraship/cmake/dependencies/patches/stormlib-optimizations.patch"
    ];
  };

  thread_pool = fetchFromGitHub {
    owner = "bshoshany";
    repo = "thread-pool";
    tag = "v4.1.0";
    hash = "sha256-zhRFEmPYNFLqQCfvdAaG5VBNle9Qm8FepIIIrT9sh88=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "2ship2harkinian";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "HarbourMasters";
    repo = "2ship2harkinian";
    tag = finalAttrs.version;
    hash = "sha256-lsq2CCDOYZKYntu3B0s4PidpZ3EjyIPSSpHpmq4XN9U=";
    fetchSubmodules = true;
  };

  patches = [
    # remove fetching stb as we will patch our own
    ./0001-deps.patch
  ];

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    imagemagick
    lsb-release
    makeWrapper
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    libGL
    libpng
    libpulseaudio
    libzip
    nlohmann_json
    SDL2
    spdlog
    tinyxml-2
    zenity
  ];

  cmakeFlags = [
    (lib.cmakeBool "NON_PORTABLE" true)
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/2s2h")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_IMGUI" "${imgui'}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBGFXD" "${libgfxd}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_STORMLIB" "${stormlib'}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_THREADPOOL" "${thread_pool}")
  ];

  dontAddPrefix = true;

  # Linking fails without this
  hardeningDisable = [ "format" ];

  # Pie needs to be enabled or else it segfaults
  hardeningEnable = [ "pie" ];

  preConfigure = ''
    # mirror 2ship's stb
    mkdir stb
    cp ${stb'} ./stb/${stb'.name}
    cp ${stb_impl} ./stb/${stb_impl.name}
    substituteInPlace libultraship/cmake/dependencies/common.cmake \
      --replace-fail "\''${STB_DIR}" "$(readlink -f ./stb)"
  '';

  postBuild = ''
    cp ${gamecontrollerdb}/gamecontrollerdb.txt gamecontrollerdb.txt
    pushd ../OTRExporter
    python3 ./extract_assets.py -z ../build/ZAPD/ZAPD.out --norom --xml-root ../mm/assets/xml --custom-assets-path ../mm/assets/custom --custom-otr-file 2ship.o2r --port-ver ${finalAttrs.version}
    popd
  '';

  preInstall = ''
    # Cmake likes it here for its install paths
    cp ../OTRExporter/2ship.o2r mm/
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/2s2h/2s2h.elf $out/bin/2s2h
    install -Dm644 ../mm/linux/2s2hIcon.png $out/share/pixmaps/2s2h.png

    install -Dm644 -t $out/share/licenses/2ship2harkinian ../LICENSE
    install -Dm644 -t $out/share/licenses/2ship2harkinian/OTRExporter ../OTRExporter/LICENSE
    install -Dm644 -t $out/share/licenses/2ship2harkinian/SDL_GameControllerDB ${gamecontrollerdb}/LICENSE
    install -Dm644 -t $out/share/licenses/2ship2harkinian/ZAPDTR ../ZAPDTR/LICENSE
    install -Dm644 -t $out/share/licenses/2ship2harkinian/libgfxd ${libgfxd}/LICENSE
    install -Dm644 -t $out/share/licenses/2ship2harkinian/libultraship ../libultraship/LICENSE
    install -Dm644 -t $out/share/licenses/2ship2harkinian/thread_pool ${thread_pool}/LICENSE.txt
  '';

  postFixup = ''
    wrapProgram $out/2s2h/2s2h.elf --prefix PATH ":" ${lib.makeBinPath [ zenity ]}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "2s2h";
      icon = "2s2h";
      exec = "2s2h";
      comment = finalAttrs.meta.description;
      genericName = "2 Ship 2 Harkinian";
      desktopName = "2s2h";
      categories = [ "Game" ];
    })
  ];

  meta = {
    homepage = "https://github.com/HarbourMasters/2ship2harkinian";
    description = "A PC port of Majora's Mask with modern controls, widescreen, high-resolution, and more";
    mainProgram = "2s2h";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ qubitnano ];
    license = with lib.licenses; [
      # OTRExporter, ZAPDTR, libultraship, libgfxd, thread_pool
      mit
      # 2 Ship 2 Harkinian
      cc0
      # Reverse engineering
      unfree
    ];
    hydraPlatforms = [ ];
  };
})
