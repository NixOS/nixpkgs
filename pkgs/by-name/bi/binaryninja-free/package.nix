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
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-wm,
  libxml2,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "binaryninja-free";
  version = "5.2.8722";

  src = fetchurl {
    url = "https://github.com/Vector35/binaryninja-api/releases/download/stable/${finalAttrs.version}/binaryninja_free_linux.zip";
    hash = "sha256-YlBr/Cdjev7LWY/VsKgv/i3zHj4YR49RX69zmhhie7U=";
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
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -R . $out/

    mkdir $out/bin
    ln -s $out/binaryninja $out/bin/binaryninja

    install -Dm644 ${finalAttrs.icon} $out/share/icons/hicolor/256x256/apps/binaryninja.png

    runHook postInstall
  '';

  meta = {
    changelog = "https://binary.ninja/changelog/#${
      lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }";
    description = "Interactive decompiler, disassembler, debugger";
    homepage = "https://binary.ninja/";
    license = {
      fullName = "Binary Ninja Free Software License";
      url = "https://docs.binary.ninja/about/license.html#free-license";
      free = false;
    };
    mainProgram = "binaryninja";
    maintainers = with lib.maintainers; [
      scoder12
      timschumi
    ];
    platforms = [ "x86_64-linux" ];
  };
})
