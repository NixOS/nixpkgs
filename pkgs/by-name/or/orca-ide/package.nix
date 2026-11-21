{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
}:

let
  pname = "orca-ide";
  version = "1.4.264";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux.AppImage";
        hash = "sha256-MRcPrNvTGreybWh2DkggxmIbmC87LUjjC5I63L8TxQo=";
      }
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      fetchurl {
        url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux-arm64.AppImage";
        hash = "";
      }
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'

    cp -r ${appimageContents}/usr/share/icons $out/share/ || true
  '';

  meta = {
    description = "Next-gen IDE for working with a fleet of parallel coding agents";
    homepage = "https://github.com/stablyai/orca";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      _2hexed
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = pname;
  };
}
