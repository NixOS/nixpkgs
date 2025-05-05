{
  stdenv,
  fetchurl,
  appimageTools,

  version,
  pname,
  meta,
}:
let
  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/4ian/GDevelop/releases/download/v${version}/GDevelop-5-${version}.AppImage";
        hash = "sha256-KV6gzPiu/45ibdzMG707vd10F6qLcm+afwJWa6WlywU=";
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
    ;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${appimageContents}/gdevelop.desktop $out/share/applications
    mkdir -p $out/share/icons
    cp -r ${appimageContents}/usr/share/icons/hicolor $out/share/icons
  '';

}
