{
  stdenv,
  fetchurl,
  appimageTools,

  version,
  pname,
  meta,
  passthru,
}:
let
  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/4ian/GDevelop/releases/download/v${version}/GDevelop-5-${version}.AppImage";
        hash = "sha256-ZVQ5e7Ghj/wZDE0RvoH264KNxaHP6x5fxSWEbbYsa88=";
      }
    else
      throw "${pname}-${version} is not supported on ${stdenv.hostPlatform.system}";
  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/gdevelop.desktop --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=gdevelop'
    '';
  };
in
appimageTools.wrapType2 {
  inherit
    pname
    version
    src
    meta
    passthru
    ;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${appimageContents}/gdevelop.desktop $out/share/applications
    mkdir -p $out/share/icons
    cp -r ${appimageContents}/usr/share/icons/hicolor $out/share/icons
  '';

}
