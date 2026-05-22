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
  bzip2,
  libogg,
  libopus,
  libvorbis,
  libx11,
  opusfile,
  sdl_gamecontrollerdb,
  makeDesktopItem,
  darwin,
  glew,
  libicns,
  fixDarwinDylibNames,
}:

let

  # The following are either normally fetched during build time or a specific version is required

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
      "${_2ship2harkinian.src}/libultraship/cmake/dependencies/patches/imgui-fixes-and-config.patch"
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
    rev = "bbcbc7e3f890a5806b579361e7aa0336acd547e7";
    hash = "sha256-jRPwO1Vub0cH12YMlME6kd8zGzKmcfIrIJZYpQJeOks=";
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

  metalcpp = fetchFromGitHub {
    owner = "briaguya-ai";
    repo = "single-header-metal-cpp";
    tag = "macOS13_iOS16";
    hash = "sha256-CSYIpmq478bla2xoPL/cGYKIWAeiORxyFFZr0+ixd7I";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "2ship2harkinian";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "HarbourMasters";
    repo = "2ship2harkinian";
    tag = finalAttrs.version;
    hash = "sha256-zrV1iSI6d6vtzIyvYmSrbgijP3qZnwBkKG9L6+pq8+0=";
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
    # remove fetching stb as we will patch our own
    ./dont-fetch-stb.patch
  ];

  nativeBuildInputs = [
    cmake
    imagemagick
    makeWrapper
    ninja
    pkg-config
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
    lsb-release
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.sigtool
    fixDarwinDylibNames
    libicns
  ];

  buildInputs = [
    bzip2
    libogg
    (lib.getDev libopus)
    libpng
    libvorbis
    libzip
    nlohmann_json
    (lib.getDev opusfile)
    SDL2
    spdlog
    tinyxml-2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libpulseaudio
    libx11
    zenity
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    glew
  ];

  cmakeFlags = [
    (lib.cmakeBool "NON_PORTABLE" true)
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/2s2h")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DR_LIBS" "${dr_libs}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_IMGUI" "${imgui'}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBGFXD" "${libgfxd}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PRISM" "${prism}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_STORMLIB" "${stormlib'}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_THREADPOOL" "${thread_pool}")
    (lib.cmakeFeature "OPUS_INCLUDE_DIR" "${lib.getDev libopus}/include/opus")
    (lib.cmakeFeature "OPUSFILE_INCLUDE_DIR" "${lib.getDev opusfile}/include/opus")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_METALCPP" "${metalcpp}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SPDLOG" "${spdlog}")
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-int-conversion -Wno-implicit-int -Wno-elaborated-enum-base";

  strictDeps = true;
  __structuredAttrs = true;
  enableParallelBuilding = true;

  dontAddPrefix = true;

  # Linking fails without this
  hardeningDisable = [ "format" ];

  preConfigure = ''
    # mirror 2ship's stb
    mkdir stb
    cp ${stb'} ./stb/${stb'.name}
    cp ${stb_impl} ./stb/${stb_impl.name}
    substituteInPlace libultraship/cmake/dependencies/common.cmake \
      --replace-fail "\''${STB_DIR}" "$(readlink -f ./stb)"
  '';

  postPatch = ''
    substituteInPlace mm/src/boot/build.c.in \
    --replace-fail "@CMAKE_PROJECT_GIT_BRANCH@" "$(cat GIT_BRANCH)" \
    --replace-fail "@CMAKE_PROJECT_GIT_COMMIT_HASH@" "$(cat GIT_COMMIT_HASH)" \
    --replace-fail "@CMAKE_PROJECT_GIT_COMMIT_TAG@" "$(cat GIT_COMMIT_TAG)"
  '';

  postBuild = ''
    port_ver=$(grep CMAKE_PROJECT_VERSION: "$PWD/CMakeCache.txt" | cut -d= -f2)
    cp ${sdl_gamecontrollerdb}/share/gamecontrollerdb.txt gamecontrollerdb.txt
    pushd ../OTRExporter
    python3 ./extract_assets.py -z ../build/ZAPD/ZAPD.out --norom --xml-root ../mm/assets/xml --custom-assets-path ../mm/assets/custom --custom-otr-file 2ship.o2r --port-ver $port_ver
    popd
  '';

  preInstall = ''
    # Cmake likes it here for its install paths
    cp ../OTRExporter/2ship.o2r mm/
  '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/bin
      ln -s $out/2s2h/2s2h.elf $out/bin/2s2h
      install -Dm644 ../mm/linux/2s2hIcon.png $out/share/icons/hicolor/512x512/apps/2s2h.png
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Recreate the macOS bundle (without using cpack)
      # We mirror the structure of the bundle distributed by the project

      mkdir -p $out/Applications/2s2h.app/Contents
      cp $src/mm/macosx/Info.plist.in $out/Applications/2s2h.app/Contents/Info.plist
      substituteInPlace $out/Applications/2s2h.app/Contents/Info.plist \
        --replace-fail "@CMAKE_PROJECT_VERSION@" "${finalAttrs.version}"

      mv $out/MacOS $out/Applications/2s2h.app/Contents/MacOS

      # "2s2h" contains all resources that are in "Resources" in the official bundle.
      # We move them to the right place and symlink them back to $out/2s2h,
      # as that's where the game expects them.
      mv $out/Resources $out/Applications/2s2h.app/Contents/Resources
      mv $out/2s2h/* $out/Applications/2s2h.app/Contents/Resources
      rm -rf $out/2s2h
      ln -s $out/Applications/2s2h.app/Contents/Resources $out/2s2h

      # Copy icons
      cp -r ../build/macosx/2s2h.icns $out/Applications/2s2h.app/Contents/Resources/2s2h.icns

      # Codesign (ad-hoc)
      codesign -f -s - $out/Applications/2s2h.app/Contents/MacOS/2s2h
    ''
    + ''
      install -Dm644 -t $out/share/licenses/2ship2harkinian ../LICENSE
      install -Dm644 -t $out/share/licenses/2ship2harkinian/OTRExporter ../OTRExporter/LICENSE
      install -Dm644 -t $out/share/licenses/2ship2harkinian/ZAPDTR ../ZAPDTR/LICENSE
      install -Dm644 -t $out/share/licenses/2ship2harkinian/libgfxd ${libgfxd}/LICENSE
      install -Dm644 -t $out/share/licenses/2ship2harkinian/libultraship ../libultraship/LICENSE
      install -Dm644 -t $out/share/licenses/2ship2harkinian/thread_pool ${thread_pool}/LICENSE.txt
    '';

  fixupPhase = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/2s2h/2s2h.elf --prefix PATH ":" ${lib.makeBinPath [ zenity ]}
  '';

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
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
    description = "PC port of Majora's Mask with modern controls, widescreen, high-resolution, and more";
    mainProgram = "2s2h";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      qubitnano
      matteopacini
    ];
    license = with lib.licenses; [
      # OTRExporter, ZAPDTR, libultraship, libgfxd, thread_pool
      mit
      # 2 Ship 2 Harkinian
      cc0
      # Reverse engineering
      unfree
    ];
  };
})
