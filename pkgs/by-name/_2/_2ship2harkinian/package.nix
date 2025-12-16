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
  libX11,
  opusfile,
  sdl_gamecontrollerdb,
  makeDesktopItem,
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

in
stdenv.mkDerivation (finalAttrs: {
  pname = "2ship2harkinian";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "HarbourMasters";
    repo = "2ship2harkinian";
    tag = finalAttrs.version;
    hash = "sha256-EC8o5FIP/eXa+0LZt0C8EWHzKVAniv9SIXkZdbibcxg=";
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
    # remove fetching stb as we will patch our own
    ./dont-fetch-stb.patch
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
    bzip2
    libGL
    libogg
    (lib.getDev libopus)
    libpng
    libpulseaudio
    libvorbis
    libX11
    libzip
    nlohmann_json
    (lib.getDev opusfile)
    SDL2
    spdlog
    tinyxml-2
    zenity
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
  ];

  strictDeps = true;

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

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/2s2h/2s2h.elf $out/bin/2s2h
    install -Dm644 ../mm/linux/2s2hIcon.png $out/share/pixmaps/2s2h.png

    install -Dm644 -t $out/share/licenses/2ship2harkinian ../LICENSE
    install -Dm644 -t $out/share/licenses/2ship2harkinian/OTRExporter ../OTRExporter/LICENSE
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
    description = "PC port of Majora's Mask with modern controls, widescreen, high-resolution, and more";
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
  };
})
