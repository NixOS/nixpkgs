{
  lib,
  stdenv,
  fetchFromGitHub,
  abseil-cpp,
  alsa-lib,
  cmake,
  curlFull,
  cxxopts,
  dbus,
  fetchzip,
  fmt,
  freetype,
  libGL,
  libglvnd,
  libpng,
  libpulseaudio,
  libusb1,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxkbcommon,
  libxrandr,
  libxscrnsaver,
  libxtst,
  luau,
  makeWrapper,
  miniz,
  ninja,
  nlohmann_json,
  nodtool,
  pkg-config,
  python3,
  rustPlatform,
  sdl3,
  sqlite,
  tracy,
  vulkan-loader,
  wayland,
  xxhash,
  yaml-cpp,
  zlib,
  zstd,
}:

let
  dawnSrc = fetchzip (
    {
      x86_64-linux = {
        url = "https://github.com/encounter/dawn/releases/download/v20260807.225922/dawn-linux-x86_64.tar.gz";
        hash = "sha256-deRtiZ221q6PO9zejJBwa56fCM63KEh6y2p7nM+MOYU=";
      };
      aarch64-linux = {
        url = "https://github.com/encounter/dawn/releases/download/v20260807.225922/dawn-linux-aarch64.tar.gz";
        hash = "sha256-WUs7dDxNbQtt5x8AIDmVuFWhcZVgSyUUuRJvr5yrREo=";
      };
    }
    .${stdenv.hostPlatform.system}
    // {
      stripRoot = false;
    }
  );
  embedSrc = fetchFromGitHub {
    owner = "TwilitRealm";
    repo = "embed";
    tag = "twilit-v2";
    hash = "sha256-xsEtUwYgCnYZoV5xVmVdWLgKPl/LztFGVKZZA1jG+uk=";
  };
  rmluiSrc = fetchFromGitHub {
    owner = "encounter";
    repo = "RmlUi";
    rev = "f00a0fee38391b2f927114e11bea18dc0a7dba1e";
    hash = "sha256-pyTD/WXdmJmcCgqMjn11bYFHrEshZ4/SiJVOVGSs9M0=";
  };
  symgen = rustPlatform.buildRustPackage rec {
    pname = "symgen";
    version = "1.3.6";
    src = fetchFromGitHub {
      owner = "encounter";
      repo = "symgen";
      tag = "v${version}";
      hash = "sha256-QSUGZsqnR9I50crc/XC5TAKqoGiNswd+mXl702RJLsM=";
    };
    env.GIT_COMMIT_SHA = "";
    postPatch = ''
      rm build.rs
    '';
    cargoHash = "sha256-LH6AC5vCpLHhjTP6GMhxczB+sQT0Y7z6D1VJRPdswDI=";
    meta = {
      description = "Symbol exports and link manifest generator for game modding";
      mainProgram = "symgen";
      homepage = "https://github.com/encounter/symgen";
      license = [
        lib.licenses.asl20
        lib.licenses.mit
      ];
    };
  };
  base64pp = stdenv.mkDerivation rec {
    pname = "base64pp";
    version = "0.2.0-rc0";
    src = fetchFromGitHub {
      owner = "matheusgomes28";
      repo = "base64pp";
      tag = "v${version}";
      hash = "sha256-DYdnjbdZmQFOizg2SwAu35kWA0F72tE6ywe00azlqxk=";
    };
    nativeBuildInputs = [ cmake ];
  };
  distormSrc = fetchFromGitHub {
    owner = "gdabah";
    repo = "distorm";
    tag = "3.5.2b";
    hash = "sha256-2ftEV3TMS3HT7f96k+Pwt3Mm31fVEXcHpcbbz05jycU=";
  };
  funchookSrc = fetchFromGitHub {
    owner = "kubo";
    repo = "funchook";
    rev = "2aca28efeb2a3b00c696e1c3e05b44581e118580";
    hash = "sha256-MiPeXScl7yu9btfUYcF32UlGPFFtqs1aBcL/kRMyHYE=";
  };
  imguiSrc = fetchFromGitHub {
    owner = "ocornut";
    repo = "imgui";
    tag = "v1.91.9b-docking";
    hash = "sha256-mQOJ6jCN+7VopgZ61yzaCnt4R1QLrW7+47xxMhFRHLQ=";
  };
  luaBridge3Src = fetchFromGitHub {
    owner = "TwilitRealm";
    repo = "LuaBridge3";
    tag = "twilit-v1";
    hash = "sha256-09sjxnCl1ZOJHTFUIBhwpR4zK6+uCScknjE7YDlUvJw=";
  };
  # dusklight expects the amalgamated source code from the github release
  minizAmalgamSrc = miniz.overrideAttrs (old: {
    pname = "miniz-amalgam-source";
    nativeBuildInputs = old.nativeBuildInputs ++ [ cmake ];
    cmakeFlags = [
      (lib.cmakeBool "AMALGAMATE_SOURCES" true)
      (lib.cmakeBool "BUILD_TESTS" false)
      (lib.cmakeBool "BUILD_EXAMPLES" false)
      (lib.cmakeBool "INSTALL_PROJECT" false)
    ];
    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp amalgamation/miniz.[ch] $out

      runHook postInstall
    '';
    dontFixup = true;
  });
  picosha2Src = fetchFromGitHub {
    owner = "okdshin";
    repo = "PicoSHA2";
    tag = "v1.0.1";
    hash = "sha256-3psCzbrwR+vO9TyTKOx+gEaWuHDx6pSgLOQ3DqrJsnI=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dusklight";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "TwilitRealm";
    repo = "dusklight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q7S2jXdHevAgrLZ+hO/WkeGzFTdB0OqTMT1onMVljbw=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    abseil-cpp
    alsa-lib
    base64pp
    curlFull
    cxxopts
    dbus
    fmt
    freetype
    libGL
    libglvnd
    libpng
    libpulseaudio
    libusb1
    libx11
    libxcb
    libxcursor
    libxi
    libxkbcommon
    libxrandr
    libxscrnsaver
    libxtst
    nlohmann_json
    nodtool
    sdl3
    sqlite
    vulkan-loader
    wayland
    xxhash
    yaml-cpp
    zlib
    zstd
  ];

  postUnpack = ''
    chmod -R u+w "$sourceRoot"
    sed -i '/add_subdirectory(tests)/d' "$sourceRoot/extern/aurora/CMakeLists.txt"
    # devendor yaml-cpp, the later fetch gets prevented by disconnected mode
    sed -i '/MakeAvailable/a\find_package(yaml-cpp)' "$sourceRoot/mods/randomizer/CMakeLists.txt"
  '';

  # disable option for auto updates in the dusklight settings menu
  patches = [ ./disable-checkForUpdates-setting.patch ];

  postPatch = ''
    sed -i '1i #include <nlohmann/json.hpp>' src/dusk/imgui/ImGuiStateShare.cpp
    # include base64pp without having to manually add it to the build environment
    sed -i 's/#include "base64pp\/base64pp.h"/#include <base64pp.h>/' mods/randomizer/generator/utility/base64pp.hpp
  '';

  cmakeBuildType = "RelWithDebInfo";

  cmakeFlags = [
    (lib.cmakeFeature "BOREALIS_APP_DESCRIBE" "v${finalAttrs.version}")
    (lib.cmakeBool "CMAKE_DISABLE_FIND_PACKAGE_Git" true)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_BATTERY-EMBED" embedSrc.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DAWN_PREBUILT" dawnSrc.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DISTORM" distormSrc.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FUNCHOOK" funchookSrc.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_IMGUI" imguiSrc.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LUABRIDGE3" luaBridge3Src.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_LUAU" luau.src.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MINIZ" minizAmalgamSrc.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PICOSHA2" picosha2Src.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_RMLUI" rmluiSrc.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_TRACY" tracy.src.outPath)
    (lib.cmakeFeature "SYMGEN_PATH" (lib.getExe symgen))
    (lib.cmakeFeature "AURORA_SDL3_PROVIDER" "system")
    (lib.cmakeFeature "AURORA_NOD_PROVIDER" "system")
    (lib.cmakeFeature "AURORA_NOD_LINKAGE" "static")
    (lib.cmakeFeature "CMAKE_CXX_FLAGS_INIT" "-include cstring")
    (lib.cmakeBool "BUILD_SHARED_LIBS" false)
    (lib.cmakeBool "CMAKE_CROSSCOMPILING" true)
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 dusklight        $out/share/dusklight/dusklight
    cp -r ../res                    $out/share/dusklight/res
    mkdir -p $out/bin
    ln -s ../share/dusklight/dusklight   $out/bin/dusklight
    mkdir -p $out/share/dusklight/mods
    cp mods/*.dusk $out/share/dusklight/mods

    install -Dm644 \
      ../platforms/freedesktop/dev.twilitrealm.dusk.desktop \
      $out/share/applications/dev.twilitrealm.dusk.desktop

    for size in 16x16 32x32 48x48 64x64 128x128 256x256 512x512 1024x1024; do
      install -Dm644 \
        ../platforms/freedesktop/$size/apps/dev.twilitrealm.dusk.png \
        $out/share/icons/hicolor/$size/apps/dev.twilitrealm.dusk.png
    done

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/share/dusklight/dusklight \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          vulkan-loader
          libGL
          libglvnd
          alsa-lib
          libpulseaudio
        ]
      }" \
      --add-flags "--cvar=backend.checkForUpdates=false"
  '';

  meta = {
    description = "Reverse-engineered reimplementation of The Legend of Zelda: Twilight Princess";
    homepage = "https://github.com/TwilitRealm/dusklight";
    changelog = "https://github.com/TwilitRealm/dusklight/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.cc0;
    mainProgram = "dusklight";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
