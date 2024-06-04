{ lib
, qt5
, autoPatchelfHook
, unzip
, fetchzip
, portaudio
}:

qt5.mkDerivation {
  pname = "soundwire";
  version = "3.0";

  src = fetchzip {
    url = "https://web.archive.org/web/20211120182526/https://georgielabs.net/SoundWire_Server_linux64.tar.gz";
    hash = "sha256-TECuQ5WXpeikc9tXEE/wVBnRbdYd0OaIFFhsBRmaukA=";
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
  ];

  buildInputs = [
    portaudio
  ];

  installPhase = ''
    install -D SoundWire-Server.desktop $out/share/applications/SoundWireServer.desktop
    install -D SoundWireServer $out/bin/SoundWireServer
    install -D sw-icon.xpm $out/share/icons/hicolor/256x256/apps/sw-icon.xpm
  '';

  meta = with lib; {
    description = "Turn your Android device into wireless headphones / wireless speaker";
    homepage = "https://georgielabs.net/";
    maintainers = with maintainers; [ mkg20001 ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
  };
}
