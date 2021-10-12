{ lib, stdenv, fetchurl, autoPatchelfHook, makeDesktopItem, makeWrapper, copyDesktopItems, jre }:
let
  altVersion = "12.4.1";
in
stdenv.mkDerivation rec {
  pname = "connect-tunnel";
  version = "12.41.01005";

  src = {
    x86_64-linux = fetchurl {
      url = "https://software.sonicwall.com/CT-NX-VPN%20Clients/CT-${altVersion}/ConnectTunnel_Linux64-${version}.tar";
      sha256 = "3bf7c1cd7cc594ace2475a02454d2ab9926ffaf84fecc846ba6355c94c7a4e42";
    };
    i686-linux = fetchurl {
      url = "https://software.sonicwall.com/CT-NX-VPN%20Clients/CT-${altVersion}/ConnectTunnel_Linux-{version}.tar";
      sha256 = "2d0aa727b7cb141afb44b8c4470525287709d063b9dd0667ef8f85e92c983796";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ autoPatchelfHook makeWrapper copyDesktopItems ];
  buildInputs = [ stdenv.cc.cc.lib ];

  unpackPhase = ''
    runHook preUnpack

    tar -xf $src
    # Name is different between 32/64 bit
    ls ConnectTunnel*.tar.bz2 | xargs tar -xf
    tar xf "usr/local/Aventail/certs.tar.bz2"

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 644 version $out/local/Aventail/version
    install -Dm 644 cert.pem $out/local/Aventail/cert.pem
    cd usr/local/Aventail

    install -Dm 644 man/ct.5 $out/local/Aventail/man/ct.5
    install -Dm 644 nui/nui.jar $out/local/Aventail/nui/nui.jar
    install -Dm 755 AvConnect $out/local/Aventail/AvConnect # With the normal installer should be 4755

    find help -type f -exec install -Dm 644 "{}" "$out/local/Aventail/{}" \; # Copy help directory
    runHook postInstall
  '';

  postInstall = ''
    # install icon
    install -Dm644 logo.png $out/share/icons/hicolor/128x128/apps/connect-tunnel.png
  '';

  preFixup = ''
    makeWrapper ${jre}/bin/java $out/bin/startct \
      --prefix PATH : ${lib.makeBinPath [ jre ]} \
      --add-flags "-jar "$out/local/Aventail/nui/nui.jar""
    makeWrapper ${jre}/bin/java $out/bin/startctui \
      --prefix PATH : ${lib.makeBinPath [ jre ]} \
      --add-flags "-jar "$out/local/Aventail/nui/nui.jar" --mode gui" # Todo: support debug and scale args
  '';

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  desktopItems = [
    (makeDesktopItem {
      exec = "startctui";
      genericName = "SonicWall VPN Connection";
      icon = "connect-tunnel";
      name = "Connect Tunnel";
      desktopName = "Connect Tunnel";
      startupNotify = false;
      terminal = false;
      type = "Application";
      categories = "GNOME;GTK;Network";
    })
  ];

  meta = with lib; {
    description = "Provides an “in-office” experience for a remote working world with full access away from the office";
    homepage = "https://www.sonicwall.com/products/remote-access/vpn-clients/";
    maintainers = with maintainers; [ martfont ];
    license = {
      fullName = "SonicWall General Product Agreement";
      url = "https://www.sonicwall.com/legal/general-product-agreement";
      free = false;
    };
  };
}
