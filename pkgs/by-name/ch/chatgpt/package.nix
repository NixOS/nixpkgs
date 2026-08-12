{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  _7zz,
  undmg,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  alsa-lib,
  at-spi2-core,
  cairo,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  cups,
  libdrm,
  libglvnd,
  libnotify,
  libusb1,
  libxcb,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  openssl,
  pango,
  systemd,
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  xdg-utils,
  xz,
}:

let
  darwinSource = import ./source.nix;
  linuxSource = import ./source-linux.nix;

  commonMeta = {
    description = "Desktop application for ChatGPT";
    homepage = "https://" + "openai.com/chatgpt/desktop/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ amielke wattmto ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
in
if stdenv.hostPlatform.isDarwin then
  stdenvNoCC.mkDerivation {
    pname = "chatgpt";
    inherit (darwinSource) version;

    src = fetchurl darwinSource.src;

    nativeBuildInputs = [
      undmg
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications"
      mkdir -p "$out/bin"
      cp -a ChatGPT.app "$out/Applications"
      ln -s "$out/Applications/ChatGPT.app/Contents/MacOS/ChatGPT" "$out/bin/ChatGPT"

      runHook postInstall
    '';

    passthru.updateScript = ./update.sh;


    meta = commonMeta // {
      changelog = "https://" + "help.openai.com/en/articles/9703738-macos-app-release-notes";
      platforms = lib.platforms.darwin;
      mainProgram = "ChatGPT";
    };
  }
else
  let
    source =
      linuxSource.sources.${stdenv.hostPlatform.system}
        or (throw "chatgpt: unsupported Linux platform ${stdenv.hostPlatform.system}");
  in
  stdenv.mkDerivation {
    pname = "chatgpt";
    inherit (linuxSource) version;

    src = fetchurl source;

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      makeWrapper
    ];

    autoPatchelfIgnoreMissingDeps = [
      "libc.musl-x86_64.so.1"
      "libQt5Core.so.5"
      "libQt5Gui.so.5"
      "libQt5Widgets.so.5"
      "libQt6Core.so.6"
      "libQt6Gui.so.6"
      "libQt6Widgets.so.6"
    ];

    buildInputs = [
      alsa-lib
      at-spi2-core
      cairo
      dbus
      expat
      gdk-pixbuf
      glib
      gtk3
      cups
      libdrm
      libglvnd
      libnotify
      libusb1
      libxcb
      libxkbcommon
      mesa
      nspr
      nss
      openssl
      pango
      systemd
      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      xz
      stdenv.cc.cc.lib
    ];

    unpackPhase = ''
      runHook preUnpack

      dpkg-deb -x "$src" source

      runHook postUnpack
    '';

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/bin" "$out/lib" "$out/share"

      cp -r source/usr/lib/chatgpt "$out/lib/"

      if [ -d source/usr/share ]; then
        cp -r source/usr/share/. "$out/share/"
      fi

      install -Dm644 \
        source/usr/share/pixmaps/chatgpt.png \
        "$out/share/icons/hicolor/1024x1024/apps/chatgpt.png"

      install -Dm755 ${./chatgpt-launcher.sh} "$out/bin/chatgpt"

      substituteInPlace "$out/bin/chatgpt" \
        --replace-fail "@APP_ROOT@" "$out/lib/chatgpt" \
        --replace-fail "@APP_VERSION@" "${linuxSource.version}"

      wrapProgram "$out/bin/chatgpt" \
        --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}

      ln -s chatgpt "$out/bin/codex-desktop"

      if [ -d "$out/share/applications" ]; then
        for desktop in "$out"/share/applications/*.desktop; do
          [ -e "$desktop" ] || continue
          substituteInPlace "$desktop" \
            --replace-warn "/usr/bin/chatgpt" "$out/bin/chatgpt"
        done
      fi

      runHook postInstall
    '';

    passthru.updateScript = ./update-linux.sh;

    meta = commonMeta // {
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      mainProgram = "chatgpt";
    };
  }
