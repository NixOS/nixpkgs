{ lib, appimageTools, runCommand, curl, gnugrep, cacert }:

appimageTools.wrapType1 rec {
  pname = "pureref";
  version = "1.11.1";

  src = runCommand "PureRef-${version}_x64.Appimage" {
    nativeBuildInputs = [ curl gnugrep cacert ];
    outputHash = "sha256-da/dH0ruI562JylpvE9f2zMUSJ56+T7Y0xlP/xr3yhY=";
  } ''
    key="$(curl "https://www.pureref.com/download.php" --silent | grep '%3D%3D' | cut -d '"' -f2)"
    curl "https://www.pureref.com/files/build.php?build=LINUX64.Appimage&version=${version}&downloadKey=$key" --output $out
  '';

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
  '';

  meta = with lib; {
    description = "Reference Image Viewer";
    homepage = "https://www.pureref.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ elnudev ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
