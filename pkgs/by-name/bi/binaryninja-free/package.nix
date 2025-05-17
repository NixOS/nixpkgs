{
  autoPatchelfHook,
  copyDesktopItems,
  dbus,
  fetchurl,
  fontconfig,
  freetype,
  lib,
  libGLU,
  libxkbcommon,
  makeDesktopItem,
  stdenv,
  unzip,
  wayland,
  xcbutilimage,
  xcbutilkeysyms,
  xcbutilrenderutil,
  xcbutilwm,
}:
stdenv.mkDerivation rec {
  pname = "binaryninja-free";
  version = "5.0.7290";

  src = fetchurl {
    url = "https://web.archive.org/web/20250426133400/https://cdn.binary.ninja/installers/binaryninja_free_linux.zip";
    hash = "sha256-Fzdv+454Ajj8IxmdcxvcDGePFsTmmyPpnfBXge4p8iU=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/Vector35/binaryninja-api/448f40be71dffa86a6581c3696627ccc1bdf74f2/docs/img/logo.png";
    hash = "sha256-TzGAAefTknnOBj70IHe64D6VwRKqIDpL4+o9kTw0Mn4=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "com.vector35.binaryninja";
      desktopName = "Binary Ninja Free";
      comment = "A Reverse Engineering Platform";
      exec = "binaryninja";
      icon = "binaryninja";
      mimeTypes = [
        "application/x-binaryninja"
        "x-scheme-handler/binaryninja"
      ];
      categories = [ "Utility" ];
    })
  ];

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    dbus
    fontconfig
    freetype
    libGLU
    libxkbcommon
    stdenv.cc.cc.lib
    wayland
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    xcbutilwm
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -R . $out/

    mkdir $out/bin
    ln -s $out/binaryninja $out/bin/binaryninja

    install -Dm644 ${icon} $out/share/icons/hicolor/256x256/apps/binaryninja.png

    runHook postInstall
  '';

  meta = {
    changelog = "https://binary.ninja/changelog/#${lib.replaceStrings [ "." ] [ "-" ] version}";
    description = "Interactive decompiler, disassembler, debugger";
    homepage = "https://binary.ninja/";
    license = {
      fullName = "Binary Ninja Free Software License";
      url = "https://docs.binary.ninja/about/license.html#free-license";
      free = false;
    };
    mainProgram = "binaryninja";
    maintainers = with lib.maintainers; [ scoder12 ];
    platforms = [ "x86_64-linux" ];
  };
}
