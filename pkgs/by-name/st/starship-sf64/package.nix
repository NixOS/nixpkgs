{
  lib,
  fetchFromGitHub,
  applyPatches,
  writeTextFile,
  fetchurl,
  stdenv,
  replaceVars,
  yaml-cpp,
  srcOnly,
  cmake,
  copyDesktopItems,
  installShellFiles,
  lsb-release,
  makeWrapper,
  ninja,
  pkg-config,
  libGL,
  libvorbis,
  libX11,
  libzip,
  nlohmann_json,
  SDL2,
  spdlog,
  tinyxml-2,
  zenity,
  starship-sf64,
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
      tag = "v1.91.6-docking";
      hash = "sha256-28wyzzwXE02W5vbEdRCw2iOF8ONkb3M3Al8XlYBvz1A=";
    };
    patches = [
      "${starship-sf64.src}/libultraship/cmake/dependencies/patches/imgui-fixes-and-config.patch"
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
      "${starship-sf64.src}/libultraship/cmake/dependencies/patches/stormlib-optimizations.patch"
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
  pname = "starship-sf64";
  version = "1.0.0-unstable-2025-04-23";

  src = fetchFromGitHub {
    owner = "HarbourMasters";
    repo = "Starship";
    rev = "4311aeda88f5aa79c47fcaf3a707723985e90675";
    hash = "sha256-hzFAkoYtT7a1VgT4u6wrm7F4maqVa+2YapZ6nI9nqCk=";
    fetchSubmodules = true;
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
        rev = "7e635fca68d014934b4af8a1cf874f63989352b7";
        hash = "sha256-cxTaOuLXHRU8xMz9gluYz0a93O0ez2xOxbloyc1m1ns=";
      };
      yaml-cpp_src = srcOnly yaml-cpp;
      tinyxml2_src = srcOnly tinyxml-2;
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
  ];

  buildInputs = [
    libGL
    libvorbis
    libX11
    libzip
    nlohmann_json
    SDL2
    spdlog
    tinyxml-2
    zenity
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DR_LIBS" "${dr_libs}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_IMGUI" "${imgui'}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LIBGFXD" "${libgfxd}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PRISM" "${prism}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_STORMLIB" "${stormlib'}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_THREADPOOL" "${thread_pool}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_TINYXML2" "${tinyxml-2}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_YAML-CPP" "${yaml-cpp.src}")
  ];

  strictDeps = true;

  # Linking fails without this
  hardeningDisable = [ "format" ];

  preConfigure = ''
    mkdir stb
    cp ${stb'} ./stb/${stb'.name}
    cp ${stb_impl} ./stb/${stb_impl.name}
    substituteInPlace libultraship/cmake/dependencies/common.cmake \
      --replace-fail "\''${STB_DIR}" "$(readlink -f ./stb)"
  '';

  postBuild = ''
    cp ${gamecontrollerdb}/gamecontrollerdb.txt gamecontrollerdb.txt
    ./TorchExternal/src/TorchExternal-build/torch pack ../port starship.o2r o2r
  '';

  postInstall = ''
    mv Starship starship-sf64
    installBin {starship-sf64,TorchExternal/src/TorchExternal-build/torch}
    mkdir -p $out/share/starship-sf64/
    cp -r assets $out/share/starship-sf64/
    install -Dm644 -t $out/share/starship-sf64 {starship.o2r,config.yml,gamecontrollerdb.txt}
    install -Dm644 ../logo.png $out/share/pixmaps/starship-sf64.png
    install -Dm644 -t $out/share/licenses/starship-sf64 ../LICENSE.md
    install -Dm644 -t $out/share/licenses/starship-sf64/SDL_GameControllerDB ${gamecontrollerdb}/LICENSE
    install -Dm644 -t $out/share/licenses/starship-sf64/libgfxd ${libgfxd}/LICENSE
    install -Dm644 -t $out/share/licenses/starship-sf64/libultraship ../libultraship/LICENSE
    install -Dm644 -t $out/share/licenses/starship-sf64/thread_pool ${thread_pool}/LICENSE.txt
  '';

  # Unfortunately, Starship really wants a writable working directory
  # Create $HOME/.local/share/starship-sf64 and symlink required files
  # This is pretty hacky and works for now and perhaps upstream might support XDG later
  # Also wrapProgram escapes $HOME to "/homeless-shelter" so use "~" for now

  postFixup = ''
    wrapProgram $out/bin/starship-sf64 \
      --prefix PATH ":" ${lib.makeBinPath [ zenity ]} \
      --run 'mkdir -p ~/.local/share/starship-sf64' \
      --run "ln -sf $out/share/starship-sf64/starship.o2r ~/.local/share/starship-sf64/starship.o2r" \
      --run "ln -sf $out/share/starship-sf64/config.yml ~/.local/share/starship-sf64/config.yml" \
      --run "ln -sfT $out/share/starship-sf64/assets ~/.local/share/starship-sf64/assets" \
      --run "ln -sf $out/share/starship-sf64/gamecontrollerdb.txt ~/.local/share/starship-sf64/gamecontrollerdb.txt" \
      --run 'cd ~/.local/share/starship-sf64'
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "starship-sf64";
      icon = "starship-sf64";
      exec = "starship-sf64";
      comment = finalAttrs.meta.description;
      genericName = "starship-sf64";
      desktopName = "starship-sf64";
      categories = [ "Game" ];
    })
  ];

  meta = {
    homepage = "https://github.com/HarbourMasters/Starship";
    description = "SF64 PC Port";
    mainProgram = "starship-sf64";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ qubitnano ];
    license = with lib.licenses; [
      # libultraship, libgfxd, thread_pool, dr_libs, prism-processor
      mit
      # Starship
      cc0
      # Reverse engineering
      unfree
    ];
    hydraPlatforms = [ ];
  };
})
