  {
    lib,
    stdenv,
    fetchFromGitHub,
    cmake,
    pcre2,

    jsoncpp,
    portmidi,
    zlib,
    curl,
    deutex,
    libpng,
    pkg-config,
    makeWrapper,
    SDL2,
    SDL2_mixer,
    wxGTK32,
    miniupnpc,
    enableUPnP ? true,
    enablePortmini ? true,
    makeDesktopItem,
    copyDesktopItems,

  }:

  stdenv.mkDerivation rec {
    pname = "odamex";
    version = "11.0.0";

    src = fetchFromGitHub {
      owner = "odamex";
      repo = "odamex";
      rev = version;
      hash = "sha256-vJyrz5qZKQRQW4F7gZ9Fs5tYnxfBfw33kCHZNnqKZT8=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      pkg-config
      makeWrapper
      cmake
      copyDesktopItems
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
    ];

    buildInputs = [
      deutex
      SDL2
      SDL2_mixer
      wxGTK32
      zlib
      curl
      pcre2
      jsoncpp

      libpng
    ] ++ lib.optionals enableUPnP [ miniupnpc ] ++ lib.optionals enablePortmini [ portmidi ];

    desktopItems = [
      (makeDesktopItem {
        name = "odalaunch";
        desktopName = "Odalaunch";
        exec = "odalaunch";
        icon = "odalaunch";
        type = "Application";
        comment = "Server Browser for Odamex";
        categories = [
          "Game"
          "ActionGame"
        ];
      })

      (makeDesktopItem {
        name = "odamex";
        desktopName = "Odamex";
        exec = "odamex -waddir /usr/share/doom"; # TODO replace in after phase
        icon = "odamex";
        type = "Application";
        comment = "A Doom multiplayer game engine";
        categories = [
          "Game"
          "ActionGame"
        ];
      })

      (makeDesktopItem {
        desktopName = "Odamex server";
        name = "odasrv";
        exec = "odasrv";
        icon = "odasrv";
        type = "Application";
        terminal = true;
        comment = "Run an Odamex game server";
        categories = [
          "Network"

        ];
      })

    ];

    meta = {
      description = "Odamex - Online Multiplayer Doom port with a strong focus on the original gameplay while providing a breadth of enhancements";
      homepage = "https://github.com/odamex/odamex";
      changelog = "https://github.com/odamex/odamex/blob/${version}/CHANGELOG";
      license = lib.licenses.gpl2Only;
      maintainers = with lib.maintainers; [ ];
      mainProgram = "odamex";
      platforms = lib.platforms.all;
    };
  }
