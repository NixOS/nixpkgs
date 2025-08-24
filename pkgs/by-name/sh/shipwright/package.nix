{
  apple-sdk_13,
  stdenv,
  cmake,
  lsb-release,
  ninja,
  lib,
  fetchFromGitHub,
  fetchurl,
  copyDesktopItems,
  makeDesktopItem,
  python3,
  glew,
  boost,
  SDL2,
  SDL2_net,
  pkg-config,
  libpulseaudio,
  libpng,
  imagemagick,
  zenity,
  makeWrapper,
  darwin,
  libicns,
  libzip,
  nlohmann_json,
  tinyxml-2,
  spdlog,
  writeTextFile,
  fixDarwinDylibNames,
  applyPatches,
  shipwright,
}:

let

  # The following would normally get fetched at build time, or a specific version is required

  gamecontrollerdb = fetchFromGitHub {
    owner = "mdqinc";
    repo = "SDL_GameControllerDB";
    rev = "a74711e1e87733ccdf02d7020d8fa9e4fa67176e";
    hash = "sha256-rXC4akz9BaKzr/C2CryZC6RGk6+fGVG7RsQryUFUUk0=";
  };

  imgui' = applyPatches {
    src = fetchFromGitHub {
      owner = "ocornut";
      repo = "imgui";
      tag = "v1.91.6-docking";
      hash = "sha256-28wyzzwXE02W5vbEdRCw2iOF8ONkb3M3Al8XlYBvz1A=";
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

  prism = fetchFromGitHub {
    owner = "KiritoDv";
    repo = "prism-processor";
    rev = "fb3f8b4a2d14dfcbae654d0f0e59a73b6f6ca850";
    hash = "sha256-gGdQSpX/TgCNZ0uyIDdnazgVHpAQhl30e+V0aVvTFMM=";
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
in
stdenv.mkDerivation (finalAttrs: {
  pname = "shipwright";
  version = "9.0.5";
  src = fetchFromGitHub {
    owner = "harbourmasters";
    repo = "shipwright";
    tag = finalAttrs.version;
    hash = "sha256-F5d4u3Nq/+yYiOgkH/bwWPhZDxgBpJ5ktee0Hc5UmEo=";
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
    boost
    glew
    SDL2
    SDL2_net
    libpng
    libzip
    nlohmann_json
    tinyxml-2
    spdlog
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libpulseaudio
    zenity
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Metal.hpp requires macOS 13.x min.
    apple-sdk_13
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_REMOTE_CONTROL" true)
    (lib.cmakeBool "NON_PORTABLE" true)
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/lib")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_IMGUI" "${imgui'}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBGFXD" "${libgfxd}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PRISM" "${prism}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_STORMLIB" "${stormlib'}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_THREADPOOL" "${thread_pool}")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_METALCPP" "${metalcpp}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SPDLOG" "${spdlog}")
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-int-conversion -Wno-implicit-int -Wno-elaborated-enum-base";

  dontAddPrefix = true;

  # Linking fails without this
  hardeningDisable = [ "format" ];

  preConfigure = ''
    mkdir stb
    cp ${stb'} ./stb/${stb'.name}
    cp ${stb_impl} ./stb/${stb_impl.name}
    substituteInPlace libultraship/cmake/dependencies/common.cmake \
      --replace-fail "\''${STB_DIR}" "$(readlink -f ./stb)"
  '';

  postPatch = ''
    substituteInPlace soh/src/boot/build.c.in \
    --replace-fail "@CMAKE_PROJECT_GIT_BRANCH@" "$(cat GIT_BRANCH)" \
    --replace-fail "@CMAKE_PROJECT_GIT_COMMIT_HASH@" "$(cat GIT_COMMIT_HASH)" \
    --replace-fail "@CMAKE_PROJECT_GIT_COMMIT_TAG@" "$(cat GIT_COMMIT_TAG)"
  '';

  postBuild = ''
    port_ver=$(grep CMAKE_PROJECT_VERSION: "$PWD/CMakeCache.txt" | cut -d= -f2)
    cp ${gamecontrollerdb}/gamecontrollerdb.txt gamecontrollerdb.txt
    mv ../libultraship/src/graphic/Fast3D/shaders ../soh/assets/custom
    pushd ../OTRExporter
    python3 ./extract_assets.py -z ../build/ZAPD/ZAPD.out --norom --xml-root ../soh/assets/xml --custom-assets-path ../soh/assets/custom --custom-otr-file soh.otr --port-ver $port_ver
    popd
  '';

  preInstall = ''
    # Cmake likes it here for its install paths
    cp ../OTRExporter/soh.otr soh/soh.otr
  '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/bin
      ln -s $out/lib/soh.elf $out/bin/soh
      install -Dm644 ../soh/macosx/sohIcon.png $out/share/pixmaps/soh.png
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
    maintainers = with lib.maintainers; [
      j0lol
      matteopacini
    ];
    license = with lib.licenses; [
      # OTRExporter, OTRGui, ZAPDTR, libultraship
      mit
      # Ship of Harkinian itself
      unfree
    ];
  };
})
