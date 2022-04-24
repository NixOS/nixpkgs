{ lib, stdenv
, fetchurl
, appimageTools
, makeWrapper
, electron
, xorg
, pipewire
}:

stdenv.mkDerivation rec {
  pname = "jitsi-meet-electron";
  version = "2022.1.1";

  src = fetchurl {
    url = "https://github.com/jitsi/jitsi-meet-electron/releases/download/v${version}/jitsi-meet-x86_64.AppImage";
    sha256 = "0x3fdqgjnsd570b7nszfx3h8l5c8x2kg32ig85n2a2g481c7xi6l";
    name = "${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/applications

    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/jitsi-meet.desktop $out/share/applications/${pname}.desktop
    cp -a ${appimageContents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc xorg.libXtst pipewire ]}"
  '';

  meta = with lib; {
    description = "Jitsi Meet desktop application powered by Electron";
    homepage = "https://github.com/jitsi/jitsi-meet-electron";
    license = licenses.asl20;
    maintainers = teams.jitsi.members;
    platforms = [ "x86_64-linux" ];
  };
}
