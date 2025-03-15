{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
}:
let
  version = "5.5.225";
  pname = "gdevelop";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/4ian/GDevelop/releases/download/v${version}/GDevelop-5-${version}.AppImage";
        sha256 = "sha256-ACNmO5hYfLEaJV6wntH4PZoHcB2T/+WFe2E5Ir/5c4U=";
      }
    else
      throw "${pname}-${version} is not supported on ${stdenv.hostPlatform.system}";
  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/gdevelop.desktop --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=gdevelop'
    '';
  };
  dontPatchELF = true;
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${appimageContents}/gdevelop.desktop $out/share/applications
    mkdir -p $out/share/icons
    cp -r ${appimageContents}/usr/share/icons/hicolor $out/share/icons
  '';

  meta = {
    description = "Graphical Game Development Studio";
    homepage = "https://gdevelop.io/";
    downloadPage = "https://github.com/4ian/GDevelop/releases";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ tombert ];
    mainProgram = "gdevelop";
    platforms = [ "x86_64-linux" ];
  };
}
