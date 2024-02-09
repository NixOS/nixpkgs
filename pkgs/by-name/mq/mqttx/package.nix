{ lib
, stdenv
, fetchurl
, appimageTools
, imagemagick
}:

let
  pname = "mqttx";
  version = "1.9.8";

  suffixedUrl = suffix: "https://github.com/emqx/MQTTX/releases/download/v${version}/MQTTX-${version}${suffix}.AppImage";
  sources = {
    "aarch64-linux" = fetchurl {
      url = suffixedUrl "-arm64";
      hash = "sha256-pdR9LwWgFdO0Dtn7ByyYKpLrfoBnl75TzQ31aIAJ/gs=";
    };
    "x86_64-linux" = fetchurl {
      url = suffixedUrl "";
      hash = "sha256-XHAroiFuUcK0aUleNDskI1bfVX7HfTvIvSup9gKJj1w=";
    };
  };

  src = sources.${stdenv.hostPlatform.system}
    or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ ];

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/${pname}.png $out/share/icons/hicolor/1024x1024/apps/${pname}.png

    ${imagemagick}/bin/convert ${appimageContents}/mqttx.png -resize 512x512 ${pname}_512.png
    install -m 444 -D ${pname}_512.png $out/share/icons/hicolor/512x512/apps/${pname}.png

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Powerful cross-platform MQTT 5.0 Desktop, CLI, and WebSocket client tools";
    homepage = "https://mqttx.app/";
    changelog = "https://github.com/emqx/MQTTX/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gaelreyrol ];
    mainProgram = "mqttx";
  };
}
