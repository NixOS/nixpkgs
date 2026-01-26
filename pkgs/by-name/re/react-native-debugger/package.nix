{
  lib,
  stdenv,
  fetchurl,
  unzip,
  cairo,
  libxtst,
  libxscrnsaver,
  libxrender,
  libxrandr,
  libxi,
  libxfixes,
  libxext,
  libxdamage,
  libxcursor,
  libxcomposite,
  libx11,
  libxcb,
  gdk-pixbuf,
  fontconfig,
  pango,
  atk,
  at-spi2-atk,
  at-spi2-core,
  gtk3,
  glib,
  freetype,
  dbus,
  nss,
  nspr,
  alsa-lib,
  cups,
  expat,
  udev,
  makeDesktopItem,
  libdrm,
  libxkbcommon,
  libgbm,
  makeWrapper,
}:

let
  rpath = lib.makeLibraryPath [
    cairo
    stdenv.cc.cc
    gdk-pixbuf
    fontconfig
    pango
    atk
    gtk3
    glib
    freetype
    dbus
    nss
    nspr
    alsa-lib
    cups
    expat
    udev
    at-spi2-atk
    at-spi2-core
    libdrm
    libxkbcommon
    libgbm

    libx11
    libxcursor
    libxtst
    libxcb
    libxext
    libxi
    libxdamage
    libxrandr
    libxcomposite
    libxfixes
    libxrender
    libxscrnsaver
  ];
in
stdenv.mkDerivation rec {
  pname = "react-native-debugger";
  version = "0.14.0";
  src = fetchurl {
    url = "https://github.com/jhen0409/react-native-debugger/releases/download/v${version}/rn-debugger-linux-x64.zip";
    sha256 = "sha256-RioBe0MAR47M84aavFaTJikGsJtcZDak8Tkg3WtX2l0=";
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];
  buildCommand = ''
    shopt -s extglob
    mkdir -p $out
    unzip $src -d $out

    mkdir $out/{lib,bin,share}
    mv $out/{libEGL,libGLESv2,libvk_swiftshader,libffmpeg}.so $out/lib
    mv $out/!(lib|share|bin) $out/share

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath ${rpath}:$out/lib \
      $out/share/react-native-debugger

    wrapProgram $out/share/react-native-debugger \
      --add-flags --no-sandbox

    ln -s $out/share/react-native-debugger $out/bin/react-native-debugger

    install -Dm644 "${desktopItem}/share/applications/"* \
      -t $out/share/applications/
  '';

  desktopItem = makeDesktopItem {
    name = "rndebugger";
    exec = "react-native-debugger";
    desktopName = "React Native Debugger";
    genericName = "React Native Debugger";
    categories = [
      "Development"
      "Debugger"
    ];
  };

  meta = {
    homepage = "https://github.com/jhen0409/react-native-debugger";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
    description = "Standalone app based on official debugger of React Native, and includes React Inspector / Redux DevTools";
    mainProgram = "react-native-debugger";
    maintainers = [ ];
  };
}
