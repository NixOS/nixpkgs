{
  lib,
  fetchurl,
  appimageTools,
  stdenv,
}:

let
  pname = "cables";
  version = "0.9.0";

  src = fetchurl {
    url = "https://github.com/cables-gl/cables_electron/releases/download/v${version}/cables-${version}-linux-x64.AppImage";
    sha256 = "sha256-UkvTPAb1etZt1PUTaTN1LdvF3XzO3RynSUY6ZElirZE=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/cables-${version}.desktop --replace 'Exec=AppRun' 'Exec=cables'
    '';
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/cables-${version}.desktop $out/share/applications/cables.desktop
    install -m 444 -D ${appimageContents}/cables-${version}.png $out/share/icons/hicolor/512x512/apps/cables.png
  '';

  meta = {
    description = "Standalone version of cables, a tool for creating beautiful interactive content";
    homepage = "https://cables.gl";
    changelog = "https://cables.gl/changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rubikcubed ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    broken = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64);
    mainProgram = "cables";
  };
}
