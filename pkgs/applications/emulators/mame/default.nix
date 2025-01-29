{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  SDL2,
  SDL2_ttf,
  copyDesktopItems,
  expat,
  fetchurl,
  flac,
  fontconfig,
  glm,
  installShellFiles,
  libXi,
  libXinerama,
  libjpeg,
  libpcap,
  libpulseaudio,
  makeDesktopItem,
  makeWrapper,
  pkg-config,
  portaudio,
  portmidi,
  pugixml,
  python3,
  qtbase,
  rapidjson,
  sqlite,
  utf8proc,
  versionCheckHook,
  which,
  writeScript,
  zlib,
  darwin,
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreAudioKit ForceFeedback;
in
stdenv.mkDerivation rec {
  pname = "mame";
  version = "0.273";
  srcVersion = builtins.replaceStrings [ "." ] [ "" ] version;

  src = fetchFromGitHub {
    owner = "mamedev";
    repo = "mame";
    rev = "mame${srcVersion}";
    hash = "sha256-aOBYnkdcFKDkw/KFiv0IRgpOChn8NRKD2xmbfExYGKY=";
  };

  outputs = [
    "out"
    "tools"
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
    "TOOLS=1"
    "USE_LIBSDL=1"
    # "USE_SYSTEM_LIB_ASIO=1"
    "USE_SYSTEM_LIB_EXPAT=1"
    "USE_SYSTEM_LIB_FLAC=1"
    "USE_SYSTEM_LIB_GLM=1"
    "USE_SYSTEM_LIB_JPEG=1"
    # https://www.mamedev.org/?p=523
    # "USE_SYSTEM_LIB_LUA=1"
    "USE_SYSTEM_LIB_PORTAUDIO=1"
    "USE_SYSTEM_LIB_PORTMIDI=1"
    "USE_SYSTEM_LIB_PUGIXML=1"
    "USE_SYSTEM_LIB_RAPIDJSON=1"
    "USE_SYSTEM_LIB_UTF8PROC=1"
    "USE_SYSTEM_LIB_SQLITE3=1"
    "USE_SYSTEM_LIB_ZLIB=1"
  ];

  dontWrapQtApps = true;

  # https://docs.mamedev.org/initialsetup/compilingmame.html
  buildInputs =
    [
      expat
      zlib
      flac
      portmidi
      portaudio
      utf8proc
      libjpeg
      rapidjson
      pugixml
      glm
      SDL2
      SDL2_ttf
      sqlite
      qtbase
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      libpulseaudio
      libXinerama
      libXi
      fontconfig
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libpcap
      CoreAudioKit
      ForceFeedback
    ];

  nativeBuildInputs = [
    copyDesktopItems
    installShellFiles
    makeWrapper
    pkg-config
    python3
    which
  ];

  patches = [
    # by default MAME assumes that paths with stock resources are relative and
    # that you run MAME changing to install directory, so we add absolute paths
    # here
    ./001-use-absolute-paths.diff
  ];

  # Since the bug described in https://github.com/NixOS/nixpkgs/issues/135438,
  # it is not possible to use substituteAll
  postPatch = ''
    substituteInPlace src/emu/emuopts.cpp \
      --subst-var-by mamePath "$out/opt/mame"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "MAME";
      desktopName = "MAME";
      exec = "mame";
      icon = "mame";
      type = "Application";
      genericName = "MAME is a multi-purpose emulation framework";
      comment = "Play vintage games using the MAME emulator";
      categories = [
        "Game"
        "Emulator"
      ];
      keywords = [
        "Game"
        "Emulator"
        "Arcade"
      ];
    })
  ];

  # TODO: copy shaders from src/osd/modules/opengl/shader/glsl*.*h
  # to the final package after we figure out how they work
  installPhase =
    let
      icon = fetchurl {
        url = "https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/refs/heads/master/Papirus/32x32/apps/mame.svg";
        hash = "sha256-s44Xl9UGizmddd/ugwABovM8w35P0lW9ByB69MIpG+E=";
      };
    in
    ''
      runHook preInstall

      # mame
      mkdir -p $out/opt/mame

      install -Dm755 mame -t $out/bin
      install -Dm644 ${icon} $out/share/icons/hicolor/scalable/apps/mame.svg
      installManPage docs/man/*.1 docs/man/*.6
      cp -ar {artwork,bgfx,plugins,language,ctrlr,keymaps,hash} $out/opt/mame

      # mame-tools
      for _tool in castool chdman floptool imgtool jedutil ldresample ldverify \
                   nltool nlwav pngcmp regrep romcmp split srcclean testkeys \
                   unidasm; do
         install -Dm755 $_tool -t $tools/bin
      done
      mv $tools/bin/{,mame-}split

      runHook postInstall
    '';

  # man1 is the tools documentation, man6 is the emulator documentation
  # Need to be done in postFixup otherwise multi-output hook will move it back to $out
  postFixup = ''
    moveToOutput share/man/man1 $tools
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "-h" ];

  passthru.updateScript = writeScript "mame-update-script" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts jq

    set -eu -o pipefail

    latest_version=$(curl -s https://api.github.com/repos/mamedev/mame/releases/latest | jq --raw-output .tag_name)
    update-source-version mame "''${latest_version/mame0/0.}"
  '';

  meta = {
    homepage = "https://www.mamedev.org/";
    description = "Multi-purpose emulation framework";
    longDescription = ''
      MAME's purpose is to preserve decades of software history. As electronic
      technology continues to rush forward, MAME prevents this important
      "vintage" software from being lost and forgotten. This is achieved by
      documenting the hardware and how it functions. The source code to MAME
      serves as this documentation. The fact that the software is usable serves
      primarily to validate the accuracy of the documentation (how else can you
      prove that you have recreated the hardware faithfully?). Over time, MAME
      (originally stood for Multiple Arcade Machine Emulator) absorbed the
      sister-project MESS (Multi Emulator Super System), so MAME now documents a
      wide variety of (mostly vintage) computers, video game consoles and
      calculators, in addition to the arcade video games that were its initial
      focus.
    '';
    changelog = "https://github.com/mamedev/mame/releases/download/mame${srcVersion}/whatsnew_${srcVersion}.txt";
    license = with lib.licenses; [
      bsd3
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [
      thiagokokada
      DimitarNestorov
    ];
    platforms = lib.platforms.unix;
    mainProgram = "mame";
  };
}
