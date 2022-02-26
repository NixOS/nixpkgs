{ lib
, stdenv
, alsa-lib
, CoreAudioKit
, fetchFromGitHub
, fontconfig
, ForceFeedback
, installShellFiles
, libpcap
, libpulseaudio
, libXi
, libXinerama
, makeDesktopItem
, makeWrapper
, pkg-config
, python3
, qtbase
, SDL2
, SDL2_ttf
, which
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
  version = "0.239";

  src = fetchFromGitHub {
    owner = "mamedev";
    repo = "mame";
    rev = "mame${builtins.replaceStrings [ "." ] [ "" ] version}";
    sha256 = "sha256-svclBaFkp4d6db+zWZNvZP8vWIFz/7M5N1M6WseOFEk=";
  };

  hardeningDisable = [ "fortify" ];
  NIX_CFLAGS_COMPILE = [ "-Wno-error=maybe-uninitialized" "-Wno-error=missing-braces" ];

  makeFlags = [
    "TOOLS=1"
    "USE_LIBSDL=1"
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  dontWrapQtApps = true;

  # https://docs.mamedev.org/initialsetup/compilingmame.html
  buildInputs =
    [ SDL2 SDL2_ttf qtbase ]
    ++ lib.optionals stdenv.isLinux [ alsa-lib libpulseaudio libXinerama libXi fontconfig ]
    ++ lib.optionals stdenv.isDarwin [ libpcap CoreAudioKit ForceFeedback ];

  nativeBuildInputs = [ python3 pkg-config which makeWrapper installShellFiles ];

  # by default MAME assumes that paths with stock resources
  # are relative and that you run MAME changing to
  # install directory, so we add absolute paths here
  patches = [
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

  meta = with lib; {
    description = "Is a multi-purpose emulation framework";
    homepage = "https://www.mamedev.org/";
    license = with licenses; [ bsd3 gpl2Plus ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ thiagokokada ];
    # macOS needs more time to build
    timeout = 24 * 3600;
  };
}
