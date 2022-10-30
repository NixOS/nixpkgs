{ lib
, stdenv
, alsa-lib
, CoreAudioKit
, expat
, fetchFromGitHub
, flac
, fontconfig
, ForceFeedback
, glm
, installShellFiles
, libjpeg
, libpcap
, libpulseaudio
, libXi
, libXinerama
, lua5_3
, makeDesktopItem
, makeWrapper
, pkg-config
, portaudio
, portmidi
, pugixml
, python3
, qtbase
, rapidjson
, SDL2
, SDL2_ttf
, utf8proc
, which
, writeScript
, zlib
}:

let
  desktopItem = makeDesktopItem {
    name = "MAME";
    exec = "mame${lib.optionalString stdenv.is64bit "64"}";
    desktopName = "MAME";
    genericName = "MAME is a multi-purpose emulation framework";
    categories = [ "System" "Emulator" ];
  };

  dest = "$out/opt/mame";
in
stdenv.mkDerivation rec {
  pname = "mame";
  version = "0.249";

  src = fetchFromGitHub {
    owner = "mamedev";
    repo = "mame";
    rev = "mame${builtins.replaceStrings [ "." ] [ "" ] version}";
    sha256 = "sha256-im6y/E0pQxruX2kNXZLE3fHq+zXfsstnOoC1QvH4fd4=";
  };

  hardeningDisable = [ "fortify" ];

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
    "USE_SYSTEM_LIB_LUA=1"
    "USE_SYSTEM_LIB_PORTAUDIO=1"
    "USE_SYSTEM_LIB_PORTMIDI=1"
    "USE_SYSTEM_LIB_PUGIXML=1"
    "USE_SYSTEM_LIB_RAPIDJSON=1"
    "USE_SYSTEM_LIB_UTF8PROC=1"
    "USE_SYSTEM_LIB_ZLIB=1"
  ];

  dontWrapQtApps = true;

  # https://docs.mamedev.org/initialsetup/compilingmame.html
  buildInputs = [
    expat
    zlib
    flac
    lua5_3
    portmidi
    portaudio
    utf8proc
    libjpeg
    rapidjson
    pugixml
    glm
    SDL2
    SDL2_ttf
    qtbase
  ]
  ++ lib.optionals stdenv.isLinux [ alsa-lib libpulseaudio libXinerama libXi fontconfig ]
  ++ lib.optionals stdenv.isDarwin [ libpcap CoreAudioKit ForceFeedback ];

  nativeBuildInputs = [ python3 pkg-config which makeWrapper installShellFiles ];

  patches = [
    # MAME is now generating the PDF documentation on its release script since commit:
    # https://github.com/mamedev/mame/commit/c0e93076232e794c919231e4386445d78b2d80b1
    # however this needs sphinx+latex to build, and it is available in the website
    # anyway for those who need it
    ./0001-Revert-Added-PDF-documentation-to-dist.mak.patch
    # by default MAME assumes that paths with stock resources
    # are relative and that you run MAME changing to
    # install directory, so we add absolute paths here
    ./emuopts.patch
  ];

  postPatch = ''
    substituteInPlace src/emu/emuopts.cpp \
      --subst-var-by mame ${dest}
  '';

  installPhase = ''
    make -f dist.mak PTR64=${lib.optionalString stdenv.is64bit "1"}
    mkdir -p ${dest}
    mv build/release/*/Release/mame/* ${dest}

    mkdir -p $out/bin
    find ${dest} -maxdepth 1 -executable -type f -exec mv -t $out/bin {} \;
    install -Dm755 src/osd/sdl/taputil.sh $out/bin/taputil.sh

    installManPage ${dest}/docs/man/*.1 ${dest}/docs/man/*.6

    mv artwork plugins samples ${dest}
  '' + lib.optionalString stdenv.isLinux ''
    mkdir -p $out/share
    ln -s ${desktopItem}/share/applications $out/share
  '';

  enableParallelBuilding = true;

  passthru.updateScript = writeScript "mame-update-script" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts jq

    set -eu -o pipefail

    latest_version=$(curl -s https://api.github.com/repos/mamedev/mame/releases/latest | jq --raw-output .tag_name)
    update-source-version mame "''${latest_version/mame0/0.}"
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Is a multi-purpose emulation framework";
    homepage = "https://www.mamedev.org/";
    license = with licenses; [ bsd3 gpl2Plus ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ thiagokokada ];
  };
}
