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
  msaClientID ? null,
  msaRequired ? true,
  gamemodeSupport ? stdenv.isLinux,
  enableLTO ? false,
}:

/*
    It's intended to NOT require an account to use the launcher.
    Feel free to override and set msaRequired to false on your machine.

    It's set to true by default so (mostly) nobody complains about "muh piracy",
    as if you couldn't run Minecraft without a launcher and completely bypass any DRM.

    You're paying to play on Mojang authenticated servers, not to play singleplayer.
*/

assert lib.assertMsg (
  gamemodeSupport -> stdenv.hostPlatform.isLinux
) "gamemodeSupport is only available on Linux.";

stdenv.mkDerivation (finalAttrs: {
  pname = "polymc-unwrapped";
  version = "7.0-unstable-2025-11-15";

  src = fetchFromGitHub {
    owner = "PolyMC";
    repo = "PolyMC";
    rev = "1a993d67f507aa8e675fcd6f859e1d0952f61f3b";
    hash = "sha256-2o/Kq7nYXy42vrAToXrZNAK5cFuCFbhsMCobpTZyDYk=";

    fetchSubmodules = true; # Use vendored libs
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
  ]
  ++ lib.optional (lib.versionAtLeast kdePackages.qtbase.version "6") kdePackages.qtwayland
  ++ lib.optional gamemodeSupport gamemode;

  dontWrapQtApps = true;
  doCheck = true;

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
