{
  lib,
  stdenv,
  SDL2,
  cmake,
  copyDesktopItems,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  imagemagick,
  imgui,
  libpng,
  libpulseaudio,
  libzip,
  lsb-release,
  makeDesktopItem,
  makeWrapper,
  ninja,
  nlohmann_json,
  pkg-config,
  python3,
  spdlog,
  stormlib,
  tinyxml-2,
  writeTextFile,
  zenity,
}:

let

  # This would get fetched at build time otherwise, see:
  # https://github.com/HarbourMasters/2ship2harkinian/blob/1.0.2/mm/CMakeLists.txt#L708
  gamecontrollerdb = fetchurl {
    name = "gamecontrollerdb.txt";
    url = "https://raw.githubusercontent.com/gabomdq/SDL_GameControllerDB/b1759cf84028aab89caa1c395e198c340b8dfd89/gamecontrollerdb.txt";
    hash = "sha256-7C5EkqBIhLGNJuhi3832y0ffW5Ep7iuTYXb1bL5h2Js=";
  };

  # 2ship needs a specific imgui version
  imgui' = imgui.overrideAttrs rec {
    version = "1.90.6";
    src = fetchFromGitHub {
      owner = "ocornut";
      repo = "imgui";
      rev = "v${version}-docking";
      hash = "sha256-Y8lZb1cLJF48sbuxQ3vXq6GLru/WThR78pq7LlORIzc=";
    };
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

  # Apply 2ship's patch for stormlib
  stormlib' = stormlib.overrideAttrs (prev: rec {
    version = "9.25";
    src = fetchFromGitHub {
      owner = "ladislav-zezula";
      repo = "StormLib";
      rev = "v${version}";
      hash = "sha256-HTi2FKzKCbRaP13XERUmHkJgw8IfKaRJvsK3+YxFFdc=";
    };
    nativeBuildInputs = prev.nativeBuildInputs ++ [ pkg-config ];
    patches = (prev.patches or [ ]) ++ [
      (fetchpatch {
        name = "stormlib-optimizations.patch";
        url = "https://github.com/briaguya-ai/StormLib/commit/ff338b230544f8b2bb68d2fbe075175ed2fd758c.patch";
        hash = "sha256-Jbnsu5E6PkBifcx/yULMVC//ab7tszYgktS09Azs5+4=";
      })
    ];
  });

  thread_pool = fetchFromGitHub {
    owner = "bshoshany";
    repo = "thread-pool";
    rev = "v4.1.0";
    hash = "sha256-zhRFEmPYNFLqQCfvdAaG5VBNle9Qm8FepIIIrT9sh88=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "2ship2harkinian";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "HarbourMasters";
    repo = "2ship2harkinian";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-1iSFzroKxwFpsIGNMetSlQKTKRWCy7QtgCTepFdSeY8=";
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
    SDL2
    imgui'
    libpng
    libpulseaudio
    libzip
    nlohmann_json
    spdlog
    stormlib'
    tinyxml-2
    zenity
  ];

  cmakeFlags = [
    (lib.cmakeBool "NON_PORTABLE" true)
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/2s2h")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_IMGUI" "${imgui'.src}")
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
      --replace-fail "\''${STB_DIR}" "/build/source/stb"
  '';

  postBuild = ''
    cp ${gamecontrollerdb} ${gamecontrollerdb.name}
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
      # OTRExporter, OTRGui, ZAPDTR, libultraship
      mit
      # 2 Ship 2 Harkinian
      cc0
      # Reverse engineering
      unfree
    ];
  };
})
