{ lib
, stdenvNoCC
, fetchurl
, appimageTools
, makeWrapper
}:
let
  version = "1.11.0";
  pname = "session-desktop";

  src = fetchurl {
    url = "https://github.com/oxen-io/session-desktop/releases/download/v${version}/session-desktop-linux-x86_64-${version}.AppImage";
    sha256 = "sha256-QartWtp5/OtJqQq5GXRoIQ/ytK9/YCW1ixXTUrnGwqw=";
  };
  appimage = appimageTools.wrapType2 {
    inherit version pname src;
  };
  appimageContents = appimageTools.extractType2 {
    inherit version pname src;
  };
in
stdenvNoCC.mkDerivation {
  inherit version pname;
  src = appimage;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mv bin/${pname}-${version} bin/${pname}

    mkdir -p $out/
    cp -r bin $out/bin

    mkdir -p $out/share/${pname}
    cp -a ${appimageContents}/usr/share/icons $out/share/
    install -Dm 644 ${appimageContents}/${pname}.desktop -t $out/share/applications/

    substituteInPlace $out/share/applications/${pname}.desktop --replace "AppRun" "${pname}"

    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations,UseOzonePlatform}}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Onion routing based messenger";
    homepage = "https://getsession.org/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ alexnortung ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
