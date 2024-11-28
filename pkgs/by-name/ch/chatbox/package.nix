{ lib, appimageTools, fetchurl }:
appimageTools.wrapType2 rec {
  pname = "chatbox";
  version = "1.6.1";

  src = fetchurl {
    url = "https://download.chatboxai.app/releases/Chatbox-${version}-x86_64.AppImage";
    hash = "sha256-Gr7Un5K0AJFRzy9IMYAWmn66dijsWtKwrS/o/UW4Zrk=";
  };

  meta = with lib; {
    description = "Chatbox AI is an AI client application and smart assistant.";
    homepage = "https://chatboxai.app";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = [ ];
    mainProgram = "chatbox";
    platforms = [ "x86_64-linux" ];
  };
}
