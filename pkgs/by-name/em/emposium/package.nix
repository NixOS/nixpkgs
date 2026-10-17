{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  wrapGAppsHook3,
  dbus,
  gtk3,
  webkitgtk_4_1,
  libayatana-appindicator,
  glib-networking,
  gst_all_1,
}:
stdenv.mkDerivation {
  pname = "emposium";
  version = "0.6.2";
  src = fetchurl {
    name = "emposium-0.6.2-linux-x86_64.tar.gz";
    url = "https://api.emposium.ru/v1/releases/0.6.2/downloads/linux-tar";
    sha256 = "941d4ac426cb09d9b5dbe35ef8b734bae45241a99efcfdb3a92cdec5a7762b58";
  };
  dontBuild = true;
  strictDeps = true;
  __structuredAttrs = true;
  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
  ];
  buildInputs = [
    stdenv.cc.cc.lib
    dbus
    gtk3
    webkitgtk_4_1
    libayatana-appindicator
    glib-networking
  ]
  ++ (with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-libav
  ]);
  installPhase = ''
    runHook preInstall
    install -Dm755 bin/emposium $out/bin/emposium
    install -Dm644 ru.emposium.app.desktop $out/share/applications/ru.emposium.app.desktop
    sed -i 's/^Exec=.*/Exec=emposium %U/' $out/share/applications/ru.emposium.app.desktop
    install -Dm644 emposium.png $out/share/icons/hicolor/256x256/apps/ru.emposium.app.png
    install -Dm644 LICENSE $out/share/licenses/emposium/LICENSE
    install -Dm644 THIRD-PARTY-NOTICES.txt $out/lib/emposium/THIRD-PARTY-NOTICES.txt
    mkdir -p $out/share/licenses/emposium
    ln -s $out/lib/emposium/THIRD-PARTY-NOTICES.txt $out/share/licenses/emposium/THIRD-PARTY-NOTICES.txt
    runHook postInstall
  '';
  preFixup = "gappsWrapperArgs+=(--set EMPOSIUM_MANAGED_INSTALL 1)";
  meta = {
    description = "Anime, manga and community in one application";
    homepage = "https://emposium.ru";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.amanomasato ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "emposium";
  };
}
