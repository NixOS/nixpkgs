{ lib, appimageTools, runCommand, curl, gnugrep, cacert }:

appimageTools.wrapType1 rec {
  pname = "pureref";
  version = "2.0.2";

  src = runCommand "PureRef-${version}_x64.Appimage" {
    nativeBuildInputs = [ curl gnugrep cacert ];
    outputHash = "sha256-dCiQlYtjIkh/3x3Rt3Yzbn1KN7ip37Rxv1u8D9y+EMA=";
  } ''
    key="$(curl "https://www.pureref.com/download.php" --silent | grep '%3D%3D' | cut -d '"' -f2)"
    curl -L "https://www.pureref.com/files/build.php?build=LINUX64.Appimage&version=${version}&downloadKey=$key" --output $out
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
