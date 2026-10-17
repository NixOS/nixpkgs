{
  lib,
  fetchFromGitHub,
  applyPatches,
  lighthouse-bk64,
  writeTextFile,
  fetchurl,
  stdenv,
  replaceVars,
  srcOnly,
  tinyxml-2,
  cmake,
  copyDesktopItems,
  installShellFiles,
  lsb-release,
  makeWrapper,
  ninja,
  pkg-config,
  python3,
  libopus,
  opusfile,
  libGL,
  libogg,
  libvorbis,
  libx11,
  libzip,
  nlohmann_json,
  SDL2,
  SDL2_net,
  spdlog,
  zenity,
  zlib,
  stb,
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
      "${lighthouse-bk64.src}/libultraship/cmake/dependencies/patches/imgui-fixes-and-config.patch"
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

  stormlib' = applyPatches {
    src = fetchFromGitHub {
      owner = "ladislav-zezula";
      repo = "StormLib";
      tag = "v9.25";
      hash = "sha256-HTi2FKzKCbRaP13XERUmHkJgw8IfKaRJvsK3+YxFFdc=";
    };
    patches = [
      "${lighthouse-bk64.src}/libultraship/cmake/dependencies/patches/stormlib-optimizations.patch"
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
  pname = "lighthouse-bk64";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "HarbourMasters";
    repo = "lighthouse";
    tag = finalAttrs.version;
    hash = "sha256-7kF5DACugw9lgv+o4NZzDIvnx7ohneJfpmlcD6Fu6lM=";
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
    # Don't fetch stb as we will patch our own
    ./dont-fetch-stb.patch

    # Can't fetch these torch deps in the sandbox
    (replaceVars ./git-deps.patch {
      libgfxd_src = fetchFromGitHub {
        owner = "glankk";
        repo = "libgfxd";
        rev = "96fd3b849f38b3a7c7b7f3ff03c5921d328e6cdf";
        hash = "sha256-dedZuV0BxU6goT+rPvrofYqTz9pTA/f6eQcsvpDWdvQ=";
      };
      spdlog_src = fetchFromGitHub {
        owner = "gabime";
        repo = "spdlog";
        rev = "79524ddd08a4ec981b7fea76afd08ee05f83755d";
        hash = "sha256-bL3hQmERXNwGmDoi7+wLv/TkppGhG6cO47k1iZvJGzY=";
      };
      yaml-cpp_src = fetchFromGitHub {
        owner = "jbeder";
        repo = "yaml-cpp";
        rev = "56e3bb550c91fd7005566f19c079cb7a503223cf"; # 0.9.0
        hash = "sha256-+FOsPQY44h1g9tEw3O281LkiYKXdW2jnFKw+oTRkhGw=";
      };
      tinyxml2_src = srcOnly tinyxml-2;
      zlib_src = fetchFromGitHub {
        owner = "madler";
        repo = "zlib";
        tag = "v1.3.1";
        hash = "sha256-TkPLWSN5QcPlL9D0kc/yhH0/puE9bFND24aj5NVDKYs=";
      };
    })
  ];

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    installShellFiles
    lsb-release
    makeWrapper
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    (lib.getDev libopus)
    (lib.getDev opusfile)
    libGL
    libogg
    libvorbis
    libx11
    libzip
    nlohmann_json
    SDL2
    SDL2_net
    spdlog
    tinyxml-2
    zenity
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_ZLIB" true)
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DR_LIBS" "${dr_libs}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_IMGUI" "${imgui'}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBGFXD" "${libgfxd}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MONOCYPHER" "${monocypher}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PRISM" "${prism}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_STORMLIB" "${stormlib'}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_THREADPOOL" "${thread_pool}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_TINYXML2" "${tinyxml-2}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ZLIB" "${zlib}")
    (lib.cmakeFeature "OPUS_INCLUDE_DIR" "${lib.getDev libopus}/include/opus")
    (lib.cmakeFeature "OPUSFILE_INCLUDE_DIR" "${lib.getDev opusfile}/include/opus")
  ];

  strictDeps = true;
  __structuredAttrs = true;

  # Linking fails without this
  hardeningDisable = [ "format" ];

  preConfigure = ''
    # mirror bk's stb
    mkdir stb
    cp ${stb}/include/stb/stb_image.h ./stb/stb_image.h
    cp ${stb_impl} ./stb/${stb_impl.name}
    substituteInPlace libultraship/cmake/dependencies/common.cmake \
      --replace-fail "\''${STB_DIR}" "$(readlink -f ./stb)"
  '';

  postPatch = ''
    substituteInPlace src/port/build.c.in \
    --replace-fail "@CMAKE_PROJECT_GIT_BRANCH@" "$(cat GIT_BRANCH)" \
    --replace-fail "@CMAKE_PROJECT_GIT_COMMIT_HASH@" "$(cat GIT_COMMIT_HASH)" \
    --replace-fail "@CMAKE_PROJECT_GIT_COMMIT_TAG@" "$(cat GIT_COMMIT_TAG)"

    # We need to use GetAppDirectoryPath on nix or else it crashes
    substituteInPlace src/port/Game.cpp \
    --replace-fail "std::string base = Ship::Context::GetAppBundlePath();" "std::string base = Ship::Context::GetAppDirectoryPath();"
  '';

  postBuild = ''
    cp ${sdl_gamecontrollerdb}/share/gamecontrollerdb.txt gamecontrollerdb.txt
    cp -R ../port port_staging
    cp -R ../libultraship/src/fast/shaders port_staging/shaders
    ./TorchExternal/src/TorchExternal-build/torch pack port_staging lighthouse.o2r o2r
  '';

  postInstall = ''
    installBin Lighthouse
    mkdir -p $out/share/lighthouse-bk64
    cp -r ../assets $out/share/lighthouse-bk64/
    install -Dm644 -t $out/share/lighthouse-bk64 {lighthouse.o2r,config.yml,gamecontrollerdb.txt}
    install -Dm644 ../logo.png $out/share/icons/hicolor/256x256/apps/lighthouse-bk64.png
  '';

  # lighthouse-bk64 needs a working directory
  postFixup = ''
    wrapProgram $out/bin/Lighthouse \
      --prefix PATH ":" ${lib.makeBinPath [ zenity ]} \
      --run 'mkdir -p ~/.local/share/lighthouse-bk64' \
      --run "ln -sf $out/share/lighthouse-bk64/lighthouse.o2r ~/.local/share/lighthouse-bk64/lighthouse.o2r" \
      --run "ln -sf $out/share/lighthouse-bk64/config.yml ~/.local/share/lighthouse-bk64/config.yml" \
      --run "ln -sfT $out/share/lighthouse-bk64/assets ~/.local/share/lighthouse-bk64/assets" \
      --run "ln -sf $out/share/lighthouse-bk64/gamecontrollerdb.txt ~/.local/share/lighthouse-bk64/gamecontrollerdb.txt" \
      --run 'cd ~/.local/share/lighthouse-bk64'
    rm -r $out/assets
    rm $out/config.yml $out/lighthouse.o2r
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "lighthouse-bk64";
      icon = "lighthouse-bk64";
      exec = "Lighthouse";
      comment = finalAttrs.meta.description;
      desktopName = "Lighthouse";
      categories = [ "Game" ];
    })
  ];

  meta = {
    homepage = "https://github.com/HarbourMasters/Lighthouse";
    description = "Harbour Masters port of Banjo Kazooie";
    mainProgram = "Lighthouse";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      qubitnano
    ];
    license = with lib.licenses; [
      # ZAPDTR, libultraship, libgfxd, thread_pool
      mit
      # Lighthouse
      cc0
      # Reverse engineering
      unfree
    ];
  };
})
