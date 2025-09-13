{
  fetchurl,
  dpkg,
  autoPatchelfHook,
  gtk2,
  webkitgtk_4_1,
  stdenv,
  lib,
  makeWrapper,
  iproute2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netextender";
  version = "10.3.0-21";

  src = fetchurl {
    url = "https://software.sonicwall.com/NetExtender/NetExtender-linux-amd64-${finalAttrs.version}.deb";
    hash = "sha256-GmPEXGzQ6iT+jgwhNuTv9SzHry+84AbrrkOckPv+pc4=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    gtk2
    webkitgtk_4_1
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libwebkit2gtk-4.0.so.37"
    "libjavascriptcoregtk-4.0.so.18"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{netextender,applications}
    mkdir $out/bin

    mv usr/local/netextender/locales $out/share/netextender
    mv usr/local/netextender/{NEService,nxcli,wg,wg-quick,wireguard-go} $out/bin
    mv usr/local/netextender/com.sonicwall.NetExtender.desktop $out/share/applications
    mv usr/local/netextender/NetExtender_webkit2_41 $out/bin/NetExtender

    sed -i "s,Icon=/usr/local/netextender/nx-icon.png,Icon=$out/share/netextender/nx-icon.png,g" $out/share/applications/com.sonicwall.NetExtender.desktop
    sed -i "s,Exec=/usr/local/netextender/NetExtender,Exec=$out/bin/NetExtender,g" $out/share/applications/com.sonicwall.NetExtender.desktop

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/NEService --prefix PATH : "${lib.makeBinPath [ iproute2 ]}"
  '';

  meta = {
    homepage = "https://www.sonicwall.com";
    description = "SonicWall NetExtender Enterprise VPN Client";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.JacoMalan1 ];
    mainProgram = "NetExtender";
  };
})
