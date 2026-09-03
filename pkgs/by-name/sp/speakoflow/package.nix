{
  lib,
  appimageTools,
  fetchurl,
  desktop-file-utils,
}:

let
  pname = "speakoflow";
  version = "1.0.2";

  #fetch the appimage
  src = fetchurl {
    url = "https://github.com/AbhishekBarali/SpeakoFlow/releases/download/v${version}/SpeakoFlow_${version}_amd64.AppImage";
    hash = "sha256-x/o2GQnwdqt83UWoBp/zS4TVTkHTtaZILFrPF4V4yeY=";
  };
  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ desktop-file-utils ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications

    cp -r ${appimageContents}/usr/share/icons $out/share/

    desktop-file-install \
      --dir=$out/share/applications \
      ${appimageContents}/usr/share/applications/SpeakoFlow.desktop
  '';
  meta = with lib; {
    description = "A free, open-source, local-first voice-to-text desktop application with offline speech recognition, AI-assisted writing, speech cleanup, translation, and a system-wide voice assistant.";
    homepage = "https://speakoflow.com";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "speakoflow";
  };
}
