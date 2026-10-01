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
}:

let
  version = "Beta-12";
  libExt = if stdenv.hostPlatform.isDarwin then "dylib" else "so";

  glmCMakeHook = writeTextDir "lib/cmake/glm/glmConfig.cmake" ''
    add_library(glm::glm INTERFACE IMPORTED)
    set_target_properties(glm::glm PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${glm}/include"
    )
  '';

  dxvk-native =
    if stdenv.hostPlatform.isDarwin then
      callPackage ./dxvk-native.nix { }
    else
      dxvk_2.overrideAttrs (old: {
        mesonFlags = (old.mesonFlags or [ ]) ++ [
          (lib.mesonOption "dxvk_native_wsi" "sdl3")
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

  src = fetchFromGitHub {
    owner = "fbraz3";
    repo = "GeneralsX";
    rev = "GeneralsX-${version}";
    hash = "sha256-LsCr4NN2jIEOq/Ry6IPmiTAHOGQo5JWIRIGMN9ocAcs=";
  };

  patches = [
    ./types-compat-guards.patch
    ./wwaudio-nixpkgs-exclude.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ./dx8-nixpkgs-dxvk.patch
  ];

  postPatch = ''
    substituteInPlace cmake/curl.cmake \
      --replace-fail 'find_package(CURL CONFIG REQUIRED)' 'find_package(CURL REQUIRED)'

    cp ${./cmake/sdl3.cmake} cmake/sdl3.cmake
    cp ${./cmake/miniaudio.cmake} cmake/miniaudio.cmake

    cp ${./cmake/gamespy.cmake} cmake/gamespy.cmake
    cp ${./cmake/lzhl.cmake} cmake/lzhl.cmake
  '';

  nativeBuildInputs = [
    cmake
    git
    ninja
    pkg-config
    copyDesktopItems
    makeWrapper
    miniaudio
  ]
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
    dxvk-native
    glmCMakeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    moltenvk
    vulkan-loader
  ];

  env = {
    FETCHCONTENT_FULLY_DISCONNECTED = "ON";
    FETCHCONTENT_UPDATES_DISCONNECTED = "ON";
  };

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
    (lib.cmakeBool "FETCHCONTENT_QUIET" true)
    (lib.cmakeBool "RTS_CRASHDUMP_ENABLE" false)
  ]
  ++ [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DXVK" (toString dxvk-native))
    (lib.cmakeFeature "MINIAUDIO_INCLUDE_DIR" "${lib.getDev miniaudio}/include")
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
    changelog = "https://github.com/fbraz3/GeneralsX/releases/tag/GeneralsX-${version}";
    license = lib.licenses.gpl3Plus;
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "GeneralsX";
    maintainers = with lib.maintainers; [ ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
