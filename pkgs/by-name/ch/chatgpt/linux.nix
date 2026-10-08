{
  asar,
  glibc,
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  libgcc,
  alsa-lib,
  at-spi2-atk,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libgbm,
  libglvnd,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  nspr,
  nss,
  pango,
  udev,
  libusb1,
  openssl,
  tpm2-tss,
  stdenv,
}:

stdenvNoCC.mkDerivation {
  pname = "chatgpt";
  version = "26.1002.52244";

  src = fetchurl {
    url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_amd64.deb";
    hash = "sha256-lJjkFxMaJ4vONb//YnXSUsDTMvF6/AMT4LeCdJ9NNIo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
    asar
  ];

  buildInputs = [
    libgcc
    alsa-lib
    at-spi2-atk
    atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libgbm
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
    pango
    udev
    libusb1
    openssl
    tpm2-tss
    libglvnd
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

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    dpkg --fsys-tarfile $src | tar --extract

    substituteInPlace \
      usr/lib/chatgpt/resources/cua_node/lib/node_modules/detect-libc/lib/filesystem.js \
      --replace-fail "/usr/bin/ldd" "${glibc.bin}/bin/ldd"

    asar extract usr/lib/chatgpt/resources/app.asar app-asar

    substituteInPlace \
      app-asar/node_modules/@parcel/watcher/node_modules/detect-libc/lib/filesystem.js \
      --replace-fail "/usr/bin/ldd" "${glibc.bin}/bin/ldd"

    asar pack app-asar usr/lib/chatgpt/resources/app.asar

    mkdir -p $out
    mv usr/* $out/

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/chatgpt \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libglvnd
          stdenv.cc.cc.lib
        ]
      }
  '';

  passthru.updateScript = ./update-linux.sh;

  meta = {
    description = "Desktop application for ChatGPT";
    homepage = "https://openai.com/chatgpt/desktop/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      wattmto
      crolandojr
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "chatgpt";
  };
}
