{
  lib,
  stdenvNoCC,
  fetchurl,

  autoPatchelfHook,
  wrapGAppsHook3,

  dbus-glib,
  gtk3,
}:

stdenvNoCC.mkDerivation rec {
  pname = "fopnu";
  version = "1.67";

  src = fetchurl {
    url = "https://download2.fopnu.com/download/fopnu-${version}-1.x86_64.manualinstall.tar.gz";
    hash = "sha256-O8wmf+/moIZlxZfqozftWEABQR0qPbw41erCxfmV3Mc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus-glib
    gtk3
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D -m 0755 fopnu -t $out/bin
    install -D -m 0444 fopnu.desktop -t $out/share/applications
    install -D -m 0444 fopnu.png -t $out/share/icons/hicolor/48x48/apps

    runHook postInstall
  '';

  meta = {
    description = "P2P file sharing system";
    homepage = "https://fopnu.com";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "fopnu";
    maintainers = with lib.maintainers; [ paveloom ];
    platforms = [ "x86_64-linux" ];
  };
}
