{
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  autoPatchelfHook,
  cairo,
  cups,
  dbus,
  dpkg,
  expat,
  fetchurl,
  gdk-pixbuf,
  glib,
  gtk3,
  lib,
  libGL,
  libdrm,
  libgbm,
  libnotify,
  libusb1,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  makeWrapper,
  nspr,
  nss,
  openssl,
  pango,
  qt6Packages,
  stdenv,
  systemd,
  tpm2-tss,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "chatgpt";
  version = "26.924.22138";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/pool/main/c/chatgpt/chatgpt_${finalAttrs.version}_amd64.deb";
    hash = "sha256-zjuxqoLM3+MDetov2NGHeW6koNXtAx0OTsitzotwFOc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];
  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libGL
    libdrm
    libgbm
    libnotify
    libusb1
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    nspr
    nss
    openssl
    pango
    qt6Packages.qtbase
    stdenv.cc.cc.lib
    systemd
    tpm2-tss
  ];

  dontUnpack = true;
  dontStrip = true;
  dontWrapQtApps = true;
  # Qt5 and musl shims are bundled for other Linux environments.
  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-x86_64.so.1"
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
  ];

  installPhase = ''
    runHook preInstall

    dpkg-deb -x "$src" "$out"
    mv "$out/usr/lib" "$out/lib"
    mv "$out/usr/share" "$out/share"
    mkdir -p "$out/bin"
    makeWrapper "$out/lib/chatgpt/ChatGPT" "$out/bin/chatgpt"
    substituteInPlace "$out/share/applications/chatgpt.desktop" \
      --replace-fail 'Exec=chatgpt' "Exec=$out/bin/chatgpt"
    rm "$out/usr/bin/chatgpt"
    rmdir "$out/usr/bin" "$out/usr"

    runHook postInstall
  '';

  passthru.updateScript = ./update-linux.sh;

  meta = {
    description = "Desktop application for ChatGPT";
    homepage = "https://openai.com/chatgpt/desktop/";
    downloadPage = "https://persistent.oaistatic.com/codex-app-prod/linux/deb";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ign1x ];
    mainProgram = "chatgpt";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
