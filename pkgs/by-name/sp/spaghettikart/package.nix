{
  lib,
  fetchFromGitHub,
  applyPatches,
  writeTextFile,
  fetchurl,
  fetchpatch,
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
  SDL2_net,
  spdlog,
  tinyxml-2,
  zenity,
  sdl_gamecontrollerdb,
  spaghettikart,
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
      "${spaghettikart.src}/libultraship/cmake/dependencies/patches/imgui-fixes-and-config.patch"
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
    rev = "7ae724a6fb7df8cbf547445214a1a848aefef747";
    hash = "sha256-G7koDUxD6PgZWmoJtKTNubDHg6Eoq8I+AxIJR0h3i+A=";
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
      "${spaghettikart.src}/libultraship/cmake/dependencies/patches/stormlib-optimizations.patch"
    ];
  };

  thread_pool = fetchFromGitHub {
    owner = "bshoshany";
    repo = "thread-pool";
    tag = "v4.1.0";
    hash = "sha256-zhRFEmPYNFLqQCfvdAaG5VBNle9Qm8FepIIIrT9sh88=";
  };

  # Include cmake4 patch
  # Remove when yaml-cpp.src is updated to include it
  yaml-patched = applyPatches {
    src = yaml-cpp.src;
    patches = [
      (fetchpatch {
        name = "yaml-cpp-fix-cmake-4.patch";
        url = "https://github.com/jbeder/yaml-cpp/commit/c2680200486572baf8221ba052ef50b58ecd816e.patch";
        hash = "sha256-1kXRa+xrAbLEhcJxNV1oGHPmayj1RNIe6dDWXZA3mUA=";
      })
    ];
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "spaghettikart";
  version = "0-unstable-2025-08-07";

  src = fetchFromGitHub {
    owner = "HarbourMasters";
    repo = "SpaghettiKart";
    rev = "334fdeafd26c15e03b4f198002ad86b8422c0e2f";
    hash = "sha256-0nDaX34C7stg7S2mzPChz0fRz/t7yyevKEAPmIR+lak=";
    fetchSubmodules = true;
    deepClone = true;
    postFetch = ''
      cd $out
      (git describe --tags HEAD 2>/dev/null || echo "") > PROJECT_VERSION
      git log --pretty=format:%h -1 > PROJECT_VERSION_PATCH
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
        rev = "7e635fca68d014934b4af8a1cf874f63989352b7";
        hash = "sha256-cxTaOuLXHRU8xMz9gluYz0a93O0ez2xOxbloyc1m1ns=";
      };
      yaml-cpp_src = fetchFromGitHub {
        owner = "jbeder";
        repo = "yaml-cpp";
        rev = "28f93bdec6387d42332220afa9558060c8016795";
        hash = "sha256-59/s4Rqiiw7LKQw0UwH3vOaT/YsNVcoq3vblK0FiO5c=";
      };
      tinyxml2_src = srcOnly tinyxml-2;
    })
  ];

  # Recent builds enabled LTO which won't build with nix
  NIX_CFLAGS_COMPILE = "-fno-lto";

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
    SDL2_net
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
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_YAML-CPP" "${yaml-patched}")
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

  postPatch = ''
    substituteInPlace CMakeLists.txt \
    --replace-fail "COMMAND git describe --tags" "COMMAND echo $(cat PROJECT_VERSION)" \
    --replace-fail "COMMAND git log --pretty=format:%h -1" "COMMAND echo $(cat PROJECT_VERSION_PATCH)"
  '';

  postBuild = ''
    cp ${sdl_gamecontrollerdb}/share/gamecontrollerdb.txt gamecontrollerdb.txt
    ./TorchExternal/src/TorchExternal-build/torch pack ../assets spaghetti.o2r o2r
  '';

  postInstall = ''
    installBin Spaghettify
    mkdir -p $out/share/spaghettikart
    cp -r ../yamls $out/share/spaghettikart/
    install -Dm644 -t $out/share/spaghettikart {spaghetti.o2r,config.yml,gamecontrollerdb.txt}
    install -Dm644 ../icon.png $out/share/pixmaps/spaghettikart.png
    install -Dm644 -t $out/share/licenses/spaghettikart/libgfxd ${libgfxd}/LICENSE
    install -Dm644 -t $out/share/licenses/spaghettikart/libultraship ../libultraship/LICENSE
    install -Dm644 -t $out/share/licenses/spaghettikart/thread_pool ${thread_pool}/LICENSE.txt
  '';

  # Unfortunately, spaghettikart really wants a writable working directory
  # Create $HOME/.local/share/spaghettikart and symlink required files

  postFixup = ''
    wrapProgram $out/bin/Spaghettify \
      --prefix PATH ":" ${lib.makeBinPath [ zenity ]} \
      --run 'mkdir -p ~/.local/share/spaghettikart' \
      --run "ln -sf $out/share/spaghettikart/spaghetti.o2r ~/.local/share/spaghettikart/spaghetti.o2r" \
      --run "ln -sf $out/share/spaghettikart/config.yml ~/.local/share/spaghettikart/config.yml" \
      --run "ln -sfT $out/share/spaghettikart/yamls ~/.local/share/spaghettikart/yamls" \
      --run "ln -sf $out/share/spaghettikart/gamecontrollerdb.txt ~/.local/share/spaghettikart/gamecontrollerdb.txt" \
      --run 'cd ~/.local/share/spaghettikart'
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "spaghettikart";
      icon = "spaghettikart";
      exec = "Spaghettify";
      comment = finalAttrs.meta.description;
      genericName = "spaghettikart";
      desktopName = "spaghettikart";
      categories = [ "Game" ];
    })
  ];

  meta = {
    homepage = "https://github.com/HarbourMasters/SpaghettiKart";
    description = "Mario Kart 64 PC Port";
    mainProgram = "Spaghettify";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ qubitnano ];
    license = with lib.licenses; [
      # libultraship, libgfxd, thread_pool, dr_libs, prism-processor
      mit
      # Reverse engineering
      unfree
    ];
  };
})
