{
  lib,
  fetchurl,
  stdenv,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  gtk3,
  pango,
  harfbuzz,
  cairo,
  atk,
  glib,
  gdk-pixbuf,
  keybinder3,
  libayatana-appindicator,
  libdbusmenu,
}:
let
  version = "0.8.64";
  src = fetchurl {
    url = "https://github.com/chen08209/FlClash/releases/download/v${version}/FlClash-${version}-linux-amd64.deb";
    hash = "sha256-hr7tZVcQvqSmKkkrodAsFVEUAduHjDMB9+OGgNZNlBs=";
  };
in
stdenv.mkDerivation {
  inherit version src;
  pname = "flclash";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    dpkg
  ];

  unpackPhase = ''
    dpkg-deb -R $src .
  '';

  buildInputs = [
    gtk3
    pango
    harfbuzz
    cairo
    atk
    glib
    gdk-pixbuf
    keybinder3
    libayatana-appindicator
    libdbusmenu
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/
    cp -a ./usr/share/FlClash/ $out/app/
    cp -a ./usr/share/applications/ $out/share/applications/
    cp -a ./usr/share/icons/ $out/share/icons/

    runHook postInstall
  '';

  preFixup = ''
    mkdir -p $out/bin/
    makeWrapper $out/app/FlClash $out/bin/FlClash \
      --prefix LD_LIBRARY_PATH : "$out/app/lib"
  '';

  meta = {
    description = "Multi-platform proxy client based on ClashMeta,simple and easy to use, open-source and ad-free";
    homepage = "https://github.com/chen08209/FlClash";
    mainProgram = "FlClash";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = [ "x86_64-linux" ];
  };
}
