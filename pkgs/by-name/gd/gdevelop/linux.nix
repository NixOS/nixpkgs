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
        hash = "sha256-fvCh4GVWH37mn7tpnTXMs8J0/8o03bg1H1Zw2JtpK3k=";
      }
    else
      throw "${pname}-${version} is not supported on ${stdenv.hostPlatform.system}";
  appimageContents = appimageTools.extract {
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
