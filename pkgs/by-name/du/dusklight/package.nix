{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  abseil-cpp,
  alsa-lib,
  cmake,
  cxxopts,
  dbus,
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
  makeWrapper,
  ninja,
  nlohmann_json,
  nodtool,
  pkg-config,
  python3,
  sdl3,
  tracy,
  vulkan-loader,
  wayland,
  xxhash,
  zlib,
  zstd,
}:

let
  auroraSrc = fetchFromGitHub {
    owner = "encounter";
    repo = "aurora";
    rev = "08122911e8621acb7ded6563813b264bec1494b5";
    hash = "sha256-vdeHq7b+RHEwHN60pGU/FEWW/CqYZMJ2MC86CnF3iMg=";
  };
  borealisSrc = fetchFromGitHub {
    owner = "encounter";
    repo = "borealis";
    rev = "8a1c87eb89c8448183e8d9054bcb1efac380940c";
    hash = "sha256-dwqUh1fhDAmc1JBv0D6c8TSCNdrsDulmfhUD7GEw8EA=";
  };
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
  imguiSrc = fetchFromGitHub {
    owner = "ocornut";
    repo = "imgui";
    tag = "v1.91.9b-docking";
    hash = "sha256-mQOJ6jCN+7VopgZ61yzaCnt4R1QLrW7+47xxMhFRHLQ=";
  };
  sqliteSrc = fetchzip {
    url = "https://sqlite.org/2026/sqlite-amalgamation-3510300.zip";
    hash = "sha256-pNMR8zxaaqfAzQ0AQBOXMct4usdjey1Q0Gnitg06UhM=";
  };
  rmluiSrc = fetchzip {
    url = "https://github.com/encounter/RmlUi/archive/215513c51ee1b3b75fc794518dda0576c462279f.tar.gz";
    hash = "sha256-erJDGImoTfgr6IeZDYTsqK2bOTgVRm3F3iQGXhch5YA=";
  };
  minizSrc = fetchzip {
    url = "https://github.com/richgel999/miniz/releases/download/3.0.2/miniz-3.0.2.zip";
    hash = "sha256-DXysXkQEmoDAMMg1F8KexkwpXNyiHNzLJqXR9SMEkxk=";
    stripRoot = false;
  };
  picosha2Src = fetchFromGitHub {
    owner = "okdshin";
    repo = "PicoSHA2";
    tag = "v1.0.1";
    hash = "sha256-3psCzbrwR+vO9TyTKOx+gEaWuHDx6pSgLOQ3DqrJsnI=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dusklight";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "TwilitRealm";
    repo = "dusklight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-STM59AiwArcuVzZVyk4DsrM3aRfKdLCvd1zui/3cx5M=";
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
    vulkan-loader
    wayland
    xxhash
    zlib
    zstd
  ];

  postUnpack = ''
    chmod -R u+w "$sourceRoot"
    mkdir -p "$sourceRoot/extern/aurora" "$sourceRoot/extern/borealis"
    cp -rT --no-preserve=mode "${auroraSrc}" "$sourceRoot/extern/aurora"
    cp -rT --no-preserve=mode "${borealisSrc}" "$sourceRoot/extern/borealis"
    sed -i '/add_subdirectory(tests)/d' "$sourceRoot/extern/aurora/CMakeLists.txt"
  '';

  postPatch = ''
    sed -i '1i #include <nlohmann/json.hpp>' src/dusk/imgui/ImGuiStateShare.cpp
  '';

  cmakeBuildType = "RelWithDebInfo";

  cmakeFlags = [
    (lib.cmakeFeature "BOREALIS_APP_DESCRIBE" "v${finalAttrs.version}")
    (lib.cmakeBool "CMAKE_DISABLE_FIND_PACKAGE_Git" true)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CXXOPTS" cxxopts.src.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_NLOHMANN_JSON" nlohmann_json.src.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MINIZ" minizSrc.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PICOSHA2" picosha2Src.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DAWN_PREBUILT" dawnSrc.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_XXHASH" xxhash.src.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FMT" fmt.src.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_TRACY" tracy.src.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FREETYPE" freetype.src.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ZSTD" zstd.src.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SQLITE3" sqliteSrc.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_IMGUI" imguiSrc.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_RMLUI" rmluiSrc.outPath)
    (lib.cmakeFeature "AURORA_SDL3_PROVIDER" "system")
    (lib.cmakeFeature "AURORA_NOD_PROVIDER" "system")
    (lib.cmakeFeature "AURORA_NOD_LINKAGE" "static")
    (lib.cmakeFeature "CMAKE_CXX_FLAGS_INIT" "-include cstring")
    (lib.cmakeBool "BUILD_SHARED_LIBS" false)
    (lib.cmakeBool "CMAKE_CROSSCOMPILING" true)
    (lib.cmakeBool "DUSK_ENABLE_CODE_MODS" false)
    (lib.cmakeFeature "BOREALIS_HTTP_BACKEND" "none")
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 dusklight        $out/share/dusklight/dusklight
    cp -r ../res                    $out/share/dusklight/res
    mkdir -p $out/bin
    ln -s ../share/dusklight/dusklight   $out/bin/dusklight

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
      }"
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
