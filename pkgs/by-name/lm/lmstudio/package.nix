{ lib
, appimageTools
, fetchurl
}:

let
  pname = "lmstudio";
  version = "0.2.18";
  src = fetchurl {
    url = "https://releases.lmstudio.ai/linux/${version}/beta/LM_Studio-${version}.AppImage";
    hash = "sha256-cUa0fjV7xx6+2tnGVP7uLG0QQb44LhP2nYsn6Qn0al4=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ [ pkgs.ocl-icd ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mv $out/bin/lmstudio-${version} $out/bin/lmstudio
    cp -r ${appimageContents}/usr/share/icons $out/share
    install -m 444 -D ${appimageContents}/lm-studio.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/lm-studio.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=lmstudio'
  '';

  meta = {
    description = "LM Studio is an easy to use desktop app for experimenting with local and open-source Large Language Models (LLMs)";
    homepage = "https://lmstudio.ai/";
    license = lib.licenses.unfree;
    mainProgram = "lmstudio";
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
