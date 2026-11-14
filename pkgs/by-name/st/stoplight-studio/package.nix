{
  appimageTools,
  fetchurl,
  lib,
  stdenv,
}:
let
  pname = "stoplight-studio";
  version = "2.10.0-stable";

  src = fetchurl {
    url = "https://github.com/stoplightio/studio/releases/download/v${version}.9587.git-0533c10/stoplight-studio-linux-x86_64.AppImage";
    sha256 = "11d58q010rmvnp0jf3c975krhfr4d10rwhnd2l4np923xnq2h9d4";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/${pname}.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = {
    description = "Stoplight Studio – OpenAPI (OAS) visual editor";
    homepage = "https://stoplight.io/studio/";
    license = lib.licenses.unfreeRedistributable;
    mainProgram = "stoplight-studio";
    maintainers = with lib.maintainers; [ rhydianjenkins ];
    platforms = lib.platforms.linux;
  };
}
