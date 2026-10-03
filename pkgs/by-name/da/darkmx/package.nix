{
  lib,
  stdenvNoCC,
  fetchurl,

  autoPatchelfHook,
  wrapGAppsHook3,

  dbus-glib,
  gtk3,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "darkmx";
  version = "1.42";

  src = fetchurl {
    url = "https://download.darkmx.app/darkmx-${finalAttrs.version}-linux64.tar.gz";
    hash = "sha256-dghRD0jfMon20WRJzPLmK3JNb4BYgmvPEsTGLH77AM4=";
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

    install -D -m 0755 darkmx -t $out/bin
    install -D -m 0444 darkmx.desktop -t $out/share/applications
    install -D -m 0444 darkmx.png -t $out/share/icons/hicolor/48x48/apps

    runHook postInstall
  '';

  meta = {
    description = "Decentralized communication app that utilizes Tor hidden services to allow you to easily have an anonymous, reliable, and censorship-resistant presence on the internet";
    homepage = "https://darkmx.app/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "darkmx";
    maintainers = with lib.maintainers; [ saltrocks ];
    platforms = [ "x86_64-linux" ];
  };
})
