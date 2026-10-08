{
  stdenv,
  cmake,
  lsb-release,
  ninja,
  lib,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  python3,
  glew,
  SDL2,
  SDL2_net,
  pkg-config,
  libpulseaudio,
  imagemagick,
  zenity,
  makeWrapper,
  darwin,
  libicns,
  libzip,
  nlohmann_json,
  tinyxml-2,
  spdlog,
  stb,
  writeTextFile,
  fixDarwinDylibNames,
  applyPatches,
  shipwright,
  libopus,
  opusfile,
  libogg,
  libvorbis,
  bzip2,
  libx11,
  sdl_gamecontrollerdb,
  zlib,
}:

let

  # The following would normally get fetched at build time, or a specific version is required

  dr_libs = fetchFromGitHub {
    owner = "mackron";
    repo = "dr_libs";
    rev = "da35f9d6c7374a95353fd1df1d394d44ab66cf01";
    hash = "sha256-ydFhQ8LTYDBnRTuETtfWwIHZpRciWfqGsZC6SuViEn0=";
  };

  imgui' = applyPatches {
    src = fetchFromGitHub {
      owner = "ocornut";
      repo = "imgui";
      tag = "v1.91.9b-docking";
      hash = "sha256-mQOJ6jCN+7VopgZ61yzaCnt4R1QLrW7+47xxMhFRHLQ=";
    };
    patches = [
      "${shipwright.src}/libultraship/cmake/dependencies/patches/imgui-fixes-and-config.patch"
    ];
  };

  libgfxd = fetchFromGitHub {
    owner = "glankk";
    repo = "libgfxd";
    rev = "008f73dca8ebc9151b205959b17773a19c5bd0da";
    hash = "sha256-AmHAa3/cQdh7KAMFOtz5TQpcM6FqO9SppmDpKPTjTt8=";
  };

  monocypher = fetchFromGitHub {
    owner = "LoupVaillant";
    repo = "Monocypher";
    rev = "0d85f98c9d9b0227e42cf795cb527dff372b40a4";
    hash = "sha256-RrM8Ep/CM7U5Q4+4FAHfBknb6b0upohoiqy4f7eMye0=";
  };

  prism = fetchFromGitHub {
    owner = "KiritoDv";
    repo = "prism-processor";
    rev = "1de054450e7b3c5f777d2e3dfcb228ad120c329d";
    hash = "sha256-5MlscqbKlUm4nYW+Obf5KlnUdtHK/xlDUc4wxr52ySM=";
  };

  stb_impl = writeTextFile {
    name = "stb_impl.c";
    text = ''
      #define STB_IMAGE_IMPLEMENTATION
      #include "stb_image.h"
    '';
  };

  stormlib' = applyPatches {
    src = fetchFromGitHub {
      owner = "ladislav-zezula";
      repo = "StormLib";
      tag = "v9.25";
      hash = "sha256-HTi2FKzKCbRaP13XERUmHkJgw8IfKaRJvsK3+YxFFdc=";
    };
    patches = [
      "${shipwright.src}/libultraship/cmake/dependencies/patches/stormlib-optimizations.patch"
    ];
  };

  thread_pool = fetchFromGitHub {
    owner = "bshoshany";
    repo = "thread-pool";
    tag = "v4.1.0";
    hash = "sha256-zhRFEmPYNFLqQCfvdAaG5VBNle9Qm8FepIIIrT9sh88=";
  };

  metalcpp = fetchFromGitHub {
    owner = "briaguya-ai";
    repo = "single-header-metal-cpp";
    tag = "macOS13_iOS16";
    hash = "sha256-CSYIpmq478bla2xoPL/cGYKIWAeiORxyFFZr0+ixd7I";
  };

  yaml-cpp = fetchFromGitHub {
    owner = "jbeder";
    repo = "yaml-cpp";
    tag = "yaml-cpp-0.9.0";
    hash = "sha256-+FOsPQY44h1g9tEw3O281LkiYKXdW2jnFKw+oTRkhGw=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "shipwright";
  version = "9.3.0";
  src = fetchFromGitHub {
    owner = "harbourmasters";
    repo = "shipwright";
    tag = finalAttrs.version;
    hash = "sha256-QkPD1O79LS+xEsoIIn3eGzL8bRbZ5ISdLvrm+8Za9q8=";
    fetchSubmodules = true;
    deepClone = true;
    postFetch = ''
      cd $out
      git branch --show-current > GIT_BRANCH
      git rev-parse --short=7 HEAD > GIT_COMMIT_HASH
      (git describe --tags --abbrev=0 --exact-match HEAD 2>/dev/null || echo "") > GIT_COMMIT_TAG
      rm -rf .git
    '';
  };

  patches = [
    ./darwin-fixes.patch
    ./disable-downloading-stb_image.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    imagemagick
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    lsb-release
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libicns
    darwin.sigtool
    fixDarwinDylibNames
  ];

  buildInputs = [
    glew
    SDL2
    SDL2_net
    libzip
    nlohmann_json
    tinyxml-2
    spdlog
    (lib.getDev libopus)
    (lib.getDev opusfile)
    libogg
    libvorbis
    bzip2
    libx11
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libpulseaudio
    zenity
  ];

  cmakeFlags = [
    (lib.cmakeBool "NON_PORTABLE" true)
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/lib")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DR_LIBS" "${dr_libs}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_IMGUI" "${imgui'}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBGFXD" "${libgfxd}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MONOCYPHER" "${monocypher}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PRISM" "${prism}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_STORMLIB" "${stormlib'}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_THREADPOOL" "${thread_pool}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_TINYXML2" "${tinyxml-2.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_YAML-CPP" "${yaml-cpp}")
    (lib.cmakeFeature "OPUS_INCLUDE_DIR" "${lib.getDev libopus}/include/opus")
    (lib.cmakeFeature "OPUSFILE_INCLUDE_DIR" "${lib.getDev opusfile}/include/opus")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_METALCPP" "${metalcpp}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SPDLOG" "${spdlog}")
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-int-conversion -Wno-implicit-int -Wno-elaborated-enum-base";

  strictDeps = true;

  dontAddPrefix = true;

  # Linking fails without this
  hardeningDisable = [ "format" ];

  preConfigure = ''
    mkdir stb
    cp ${stb}/include/stb/stb_image.h ./stb/stb_image.h
    cp ${stb_impl} ./stb/${stb_impl.name}
    substituteInPlace libultraship/cmake/dependencies/common.cmake \
      --replace-fail "\''${STB_DIR}" "$(readlink -f ./stb)"
  '';

  postPatch = ''
    substituteInPlace soh/src/boot/build.c.in \
    --replace-fail "@CMAKE_PROJECT_GIT_BRANCH@" "$(cat GIT_BRANCH)" \
    --replace-fail "@CMAKE_PROJECT_GIT_COMMIT_HASH@" "$(cat GIT_COMMIT_HASH)" \
    --replace-fail "@CMAKE_PROJECT_GIT_COMMIT_TAG@" "$(cat GIT_COMMIT_TAG)"

    # Use system zlib
    substituteInPlace torch/CMakeLists.txt \
      --replace-fail "if(EMSCRIPTEN OR ANDROID)" "if(TRUE)"
  '';

  postBuild = ''
    cp ${sdl_gamecontrollerdb}/share/gamecontrollerdb.txt gamecontrollerdb.txt
  '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/bin
      ln -s $out/lib/soh.elf $out/bin/soh
      install -Dm644 ../soh/macosx/sohIcon.png $out/share/icons/soh.png
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Recreate the macOS bundle (without using cpack)
      # We mirror the structure of the bundle distributed by the project

      mkdir -p $out/Applications/soh.app/Contents
      cp $src/soh/macosx/Info.plist.in $out/Applications/soh.app/Contents/Info.plist
      substituteInPlace $out/Applications/soh.app/Contents/Info.plist \
        --replace-fail "@CMAKE_PROJECT_VERSION@" "${finalAttrs.version}"

      mv $out/MacOS $out/Applications/soh.app/Contents/MacOS

      # "lib" contains all resources that are in "Resources" in the official bundle.
      # We move them to the right place and symlink them back to $out/lib,
      # as that's where the game expects them.
      mv $out/Resources $out/Applications/soh.app/Contents/Resources
      mv $out/lib/** $out/Applications/soh.app/Contents/Resources
      rm -rf $out/lib
      ln -s $out/Applications/soh.app/Contents/Resources $out/lib

      # Copy icons
      cp -r ../build/macosx/soh.icns $out/Applications/soh.app/Contents/Resources/soh.icns

      # Codesign (ad-hoc)
      codesign -f -s - $out/Applications/soh.app/Contents/MacOS/soh
    '';

  fixupPhase = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/lib/soh.elf --prefix PATH ":" ${lib.makeBinPath [ zenity ]}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "soh";
      icon = "soh";
      exec = "soh";
      comment = finalAttrs.meta.description;
      genericName = "Ship of Harkinian";
      desktopName = "soh";
      categories = [ "Game" ];
    })
  ];

  meta = {
    homepage = "https://github.com/HarbourMasters/Shipwright";
    description = "PC port of Ocarina of Time with modern controls, widescreen, high-resolution, and more";
    mainProgram = "soh";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ matteopacini ];
    license = with lib.licenses; [
      # libultraship, Torch
      mit
      # Ship of Harkinian itself
      unfree
    ];
  };
})
