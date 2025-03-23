{
  lib,
  stdenv,
  cmake,
  curl,
  curlpp,
  srcOnly,
  fetchFromGitHub,
  fetchurl,
  fmt,
  nlohmann_json,
  qt5,
  spdlog,
  replaceVars,
  buildDayZLauncher ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "arma3-unix-launcher";
  version = "413-unstable-2025-02-10";

  src = fetchFromGitHub {
    owner = "muttleyxd";
    repo = "arma3-unix-launcher";
    rev = "7d4bcb166da3bb64ef10af421619d0b00136ebd5";
    hash = "sha256-so7fjxESUAkQfO4hO5aQTzU5lHpeJlOOfEGp0Pb89sQ=";
  };

  patches = [
    # prevent CMake from trying to get libraries on the internet
    (replaceVars ./dont_fetch_dependencies.patch {
      argparse_src = fetchFromGitHub {
        owner = "p-ranav";
        repo = "argparse";
        rev = "45664c4e9f05ff287731a9ff8b724d0c89fb6e77";
        hash = "sha256-qLD9zD6hbItDn6ZHHWBXrAWhySvqcs40xA5+C/5Fkhw=";
      };
      curlpp_src = srcOnly curlpp;
      fmt_src = fmt;
      nlohmann_json_src = nlohmann_json;
      pugixml_src = fetchFromGitHub {
        owner = "muttleyxd";
        repo = "pugixml";
        rev = "simple-build-for-a3ul";
        hash = "sha256-FpREdz6DbhnLDGOuQY9rU17SSd6ngA4WfO0kGHqGJPM=";
      };
      spdlog_src = spdlog;
      steamworkssdk_src = fetchurl {
        url = "https://github.com/julianxhokaxhiu/SteamworksSDKCI/releases/download/1.53/SteamworksSDK-v1.53.0_x64.zip";
        hash = "sha256-6PQGaPsaxBg/MHVWw2ynYW6LaNSrE9Rd9Q9ZLKFGPFA=";
      };
      # Only required for testing?
      doctest_src = null;
      trompeloeil_src = null;
    })
    # game won't launch with steam integration anyways, disable it
    ./disable_steam_integration.patch
  ];

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    cmake
    spdlog
    curl
    curlpp
  ];

  cmakeFlags = [ "-Wno-dev" ] ++ lib.optionals buildDayZLauncher [ "-DBUILD_DAYZ_LAUNCHER=ON" ];

  meta = {
    homepage = "https://github.com/muttleyxd/arma3-unix-launcher/";
    description = "Clean, intuitive Arma 3 + DayZ SA Launcher";
    license = with lib.licenses; [
      # Launcher
      mit
      # Steamworks SDK
      unfree
    ];
    maintainers = with lib.maintainers; [ DrymarchonShaun ];
    mainProgram = "arma3-unix-launcher";
    platforms = with lib.platforms; linux ++ darwin;
  };
})
