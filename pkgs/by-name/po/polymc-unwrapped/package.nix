{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  ninja,
  jdk8,
  gamemode,
  zlib,
  file,
  kdePackages,
  extra-cmake-modules,
  tomlplusplus,
  ghc_filesystem,
  msaClientID ? null,
  msaRequired ? true,
  gamemodeSupport ? stdenv.isLinux,
  enableLTO ? false,
}:

/*
    Feel free to override msaRequired to `false' on your machine, as
    it's intended to NOT require an account to use the launcher.

    It's set to true by default so (mostly) nobody complains about "muh piracy",
    as if you couldn't just avoid any form of DRM by executing the .jar file directly.

    You're paying to play on Mojang authenticated servers, singleplayer is free.
*/

let
  libnbtplusplus = fetchFromGitHub {
    owner = "PolyMC";
    repo = "libnbtplusplus";
    rev = "2203af7eeb48c45398139b583615134efd8d407f";
    hash = "sha256-TvVOjkUobYJD9itQYueELJX3wmecvEdCbJ0FinW2mL4=";
  };
in

assert lib.assertMsg (
  gamemodeSupport -> stdenv.hostPlatform.isLinux
) "gamemodeSupport is only available on Linux.";

stdenv.mkDerivation (finalAttrs: {
  pname = "polymc-unwrapped";
  version = "7.0-unstable-2025-11-15";

  src = fetchFromGitHub {
    owner = "PolyMC";
    repo = "PolyMC";
    rev = "8b0558142f995dffdd3daef5fce54377d5fcb9ac";
    hash = "sha256-pqR8JneWelshuaZj9y/Fo3BLjaMYphnDZuBKGccO2FM=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    ninja
    jdk8
    file
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.quazip
    kdePackages.qtcharts
    zlib

    tomlplusplus
    ghc_filesystem
  ]
  ++ lib.optional (lib.versionAtLeast kdePackages.qtbase.version "6") [
    kdePackages.qtwayland
    kdePackages.qt5compat
  ]
  ++ lib.optional gamemodeSupport gamemode;

  dontWrapQtApps = true;
  doCheck = true;

  postUnpack = ''
    rm -rf source/libraries/libnbtplusplus
    ln -s ${libnbtplusplus} source/libraries/libnbtplusplus
  '';

  postPatch = ''
    ### This fix will be upstreamed. PolyMC hasn't updated the MangoHud functionality for a while.

    substituteInPlace launcher/Application.cpp launcher/minecraft/MinecraftInstance.cpp \
        --replace-fail "libMangoHud_dlsym.so" "libMangoHud_shim.so" \

    ### Metadata & branding

    substituteInPlace buildconfig/BuildConfig.cpp.in \
        --replace-fail "@Launcher_GIT_COMMIT@" ${
          if (builtins.hasAttr "rev" finalAttrs.src) && (!builtins.isNull finalAttrs.src.rev) then
            finalAttrs.src.rev
          else
            "@Launcher_GIT_COMMIT@"
        } \
        --replace-fail "@Launcher_GIT_TAG@" ${
          if (builtins.hasAttr "tag" finalAttrs.src) && (!builtins.isNull finalAttrs.src.tag) then
            finalAttrs.src.tag
          else
            "@Launcher_GIT_TAG@"
        } \
        --replace-fail "@Launcher_GIT_REFSPEC@" ${
          if (builtins.hasAttr "ref" finalAttrs.src) && (!builtins.isNull finalAttrs.src.ref) then
            finalAttrs.src.ref
          else
            "@Launcher_GIT_REFSPEC@"
        } \
        --replace-fail "return vstr;" 'return vstr + "-NixOS";'
  '';

  cmakeFlags = [
    "-GNinja"
    "-DLauncher_QT_VERSION_MAJOR=${lib.versions.major kdePackages.qtbase.version}"
    "-DLauncher_BUILD_PLATFORM=nixpkgs"
  ]
  ++ lib.optionals enableLTO [ "-DENABLE_LTO=on" ]
  ++ lib.optionals (!builtins.isNull msaClientID) [ "-DLauncher_MSA_CLIENT_ID=${msaClientID}" ]
  ++ lib.optionals msaRequired [ "-DLauncher_STRICT_DRM=on" ];

  meta = with lib; {
    homepage = "https://polymc.org/";
    downloadPage = "https://polymc.org/download/";
    changelog = "https://github.com/PolyMC/PolyMC/releases";
    description = "A free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with
      their own mods, texture packs, saves, etc) and helps you manage them and
      their associated options with a simple interface.
    '';
    platforms = platforms.unix;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      hustlerone
    ];
  };
})
