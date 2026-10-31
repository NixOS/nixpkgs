{
  lib,
  stdenv,
  cmake,
  ninja,
  fetchFromGitHub,
  pkg-config,
  sdl3,
  sdl3-image,
  zlib,
  freetype,
  fontconfig,
  curl,
  ffmpeg,
  git,
  glm,
  vulkan-headers,
  vulkan-loader,
  moltenvk,
  libpng,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  desktopToDarwinBundle,
  dxvk_2,
  callPackage,
  writeTextDir,
  lzhl,
  miniaudio,
  gamespy-sdk,
  stb,
  nlohmann_json,
}:

let
  version = "1.0.3";
  libExt = if stdenv.hostPlatform.isDarwin then "dylib" else "so";
  miniaudioIncludeDir =
    if stdenv.hostPlatform.isDarwin then
      fetchFromGitHub {
        owner = "mackron";
        repo = "miniaudio";
        tag = "0.11.25";
        hash = "sha256-2k346Z/ueINPbaY20P2cbBvRfFXXH0ugdv4d7WaYt2w=";
      }
    else
      "${lib.getDev miniaudio}/include/miniaudio";

  glmCMakeHook = writeTextDir "lib/cmake/glm/glmConfig.cmake" ''
    add_library(glm::glm INTERFACE IMPORTED)
    set_target_properties(glm::glm PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${glm}/include"
    )
  '';

  gliSource = fetchFromGitHub {
    owner = "g-truc";
    repo = "gli";
    tag = "0.8.2.0";
    hash = "sha256-aUHYMipPfObfuRI93lKmV4yhJJR+Ba8cfT0XYwOb7Lg=";
  };

  gliCMakeHook = writeTextDir "lib/cmake/gli/gliConfig.cmake" ''
    add_library(gli INTERFACE IMPORTED)
    set_target_properties(gli PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${gliSource};${gliSource}/external/glm"
    )
  '';

  dxvk-native =
    if stdenv.hostPlatform.isDarwin then
      callPackage ./dxvk-native.nix { }
    else
      (dxvk_2.override { glfwSupport = false; }).overrideAttrs (old: {
        mesonFlags = (old.mesonFlags or [ ]) ++ [
          (lib.mesonEnable "native_sdl3" true)
          (lib.mesonEnable "native_sdl2" false)
          (lib.mesonEnable "native_glfw" false)
          (lib.mesonBool "enable_d3d8" true)
          (lib.mesonBool "enable_d3d9" true)
          (lib.mesonBool "enable_d3d10" false)
          (lib.mesonBool "enable_d3d11" false)
          (lib.mesonBool "enable_dxgi" false)
          (lib.mesonBool "build_id" false)
        ];

        postInstall = (old.postInstall or "") + ''
          mkdir -p $out/x64 $out/include/native
          mv $out/lib/*.so* $out/x64/
          cp -r ${old.src}/include/native $out/include/
        '';
      });

  desktopCategories = [
    "Game"
    "StrategyGame"
  ];

  games = {
    GeneralsX = {
      binary = "Generals/GeneralsX";
      icon = "generalsx";
      iconAsset = "generalsx_icon.png";
      desktopName = "GeneralsX";
      comment = "Command & Conquer: Generals cross-platform port";
    };
    GeneralsXZH = {
      binary = "GeneralsMD/GeneralsXZH";
      icon = "generalsx-zero-hour";
      iconAsset = "generalsx-zh_icon.png";
      desktopName = "GeneralsX Zero Hour";
      comment = "Command & Conquer: Generals -- Zero Hour cross-platform port";
    };
  };

  gameNames = builtins.attrNames games;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "generalsx";
  inherit version;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "fbraz3";
    repo = "GeneralsX";
    rev = version;
    hash = "sha256-9cd7mRjc6pz89otSzSdzL45SECRKCVoJ/JnBvAhgK8U=";
  };

  patches = [
    ./types-compat-guards.patch
    ./wwaudio-nixpkgs-exclude.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ./dx8-nixpkgs-dxvk.patch
  ];

  postPatch = ''
    cp ${./cmake/sdl3.cmake} cmake/sdl3.cmake
    cp ${./cmake/miniaudio.cmake} cmake/miniaudio.cmake

    cp ${./cmake/gamespy.cmake} cmake/gamespy.cmake
    cp ${./cmake/lzhl.cmake} cmake/lzhl.cmake
    cp ${./cmake/stb.cmake} cmake/stb.cmake
  '';

  nativeBuildInputs = [
    cmake
    git
    ninja
    pkg-config
    copyDesktopItems
    makeWrapper
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ miniaudio ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    sdl3
    sdl3-image
    freetype
    fontconfig
    curl
    ffmpeg
    glm
    vulkan-headers
    libpng
    zlib
    gamespy-sdk
    lzhl
    stb
    nlohmann_json
    dxvk-native
    glmCMakeHook
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ gliCMakeHook ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    moltenvk
    vulkan-loader
  ];

  cmakeFlags = [
    (lib.cmakeBool "SAGE_USE_SDL3" true)
    (lib.cmakeBool "SAGE_USE_MINIAUDIO" true)
    (lib.cmakeBool "SAGE_USE_OPENAL" false)
    (lib.cmakeBool "SAGE_UPDATE_CHECK" true)
    (lib.cmakeBool "RTS_BUILD_OPTION_FFMPEG" true)
    (lib.cmakeBool "RTS_BUILD_CORE_EXTRAS" false)
    (lib.cmakeBool "RTS_BUILD_CORE_TOOLS" false)
    (lib.cmakeBool "RTS_BUILD_ZEROHOUR" true)
    (lib.cmakeBool "RTS_BUILD_GENERALS" true)
    (lib.cmakeBool "RTS_BUILD_GENERALS_TOOLS" false)
    (lib.cmakeBool "RTS_BUILD_GENERALS_EXTRAS" false)
    (lib.cmakeBool "RTS_BUILD_ZEROHOUR_TOOLS" false)
    (lib.cmakeBool "RTS_BUILD_ZEROHOUR_EXTRAS" false)
    (lib.cmakeBool "RTS_BUILD_OPTION_SAGE_PATCH" true)
    (lib.cmakeBool "SAGE_USE_DETERMINISTIC_MATH" false)
    (lib.cmakeBool "SAGE_USE_GLM" true)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "FETCHCONTENT_QUIET" true)
    (lib.cmakeBool "RTS_CRASHDUMP_ENABLE" false)
  ]
  ++ [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DXVK" (toString dxvk-native))
    (lib.cmakeFeature "MINIAUDIO_INCLUDE_DIR" (toString miniaudioIncludeDir))
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "SAGE_USE_MOLTENVK" true)
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/icons/hicolor/512x512/apps

    ${lib.concatMapStringsSep "\n" (name: ''
      cp "${games.${name}.binary}" "$out/bin/${name}"
      install -Dm644 "$src/assets/${games.${name}.iconAsset}" \
        "$out/share/icons/hicolor/512x512/apps/${games.${name}.icon}.png"
    '') gameNames}

    install -Dm644 Patches/SagePatch/libsage_patch.${libExt} "$out/lib/libsage_patch.${libExt}"

    runHook postInstall
  '';

  postFixup = lib.concatMapStringsSep "\n" (name: ''
    wrapProgram $out/bin/${name} \
      --prefix LD_LIBRARY_PATH : ${dxvk-native}/x64 \
      --prefix DYLD_LIBRARY_PATH : ${dxvk-native}/x64 \
      --set DXVK_WSI_DRIVER SDL3
  '') gameNames;

  desktopItems = lib.mapAttrsToList (
    name: cfg:
    makeDesktopItem {
      name = cfg.icon;
      exec = name;
      icon = cfg.icon;
      comment = cfg.comment;
      desktopName = cfg.desktopName;
      categories = desktopCategories;
      startupNotify = true;
    }
  ) games;

  meta = {
    description = "Cross-platform port of Command & Conquer: Generals -- Zero Hour";
    longDescription = ''
      GeneralsX is a native cross-platform port of Command & Conquer: Generals
      and the Zero Hour expansion pack, targeting Linux and macOS with Apple
      Silicon support.

      You must provide the original game data files from a legitimate Windows
      installation of Command & Conquer: Generals or Zero Hour (e.g. via Steam,
      the Generals Collection, or an original disc). Place them in:
        ~/.local/share/GeneralsX/Generals   (for Generals)
        ~/.local/share/GeneralsX/Zero Hour  (for Zero Hour)
    '';
    homepage = "https://github.com/fbraz3/GeneralsX";
    changelog = "https://github.com/fbraz3/GeneralsX/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "GeneralsX";
    maintainers = [ ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
