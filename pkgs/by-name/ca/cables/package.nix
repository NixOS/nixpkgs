{
  lib,
  fetchurl,
  appimageTools,
  stdenv,
}:

let
  pname = "cables";
  version = "0.4.4";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/cables-gl/cables_electron/releases/download/v${version}/cables-${version}-linux-x64.AppImage";
    sha256 = "sha256-+PMENdKs/bcmszlrk0hQILZzKCV8uQbCgR0bbKMk7ic=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/${pname}-${version}.desktop --replace 'Exec=AppRun' 'Exec=cables'
    '';
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${name}.desktop $out/share/applications/cables.desktop
    install -m 444 -D ${appimageContents}/${name}.png $out/share/icons/hicolor/512x512/apps/cables.png
  '';

  meta = with lib; {
    description = "Standalone version of cables, a tool for creating beautiful interactive content.";
    homepage = "https://cables.gl";
    changelog = "https://cables.gl/changelog";
    license = licenses.mit;
    maintainers = with maintainers; [ rubikcubed ];
    platforms = with platforms; linux ++ darwin ++ windows;
    broken = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64);
    mainProgram = "cables";
  };
}
