{
  lib,
  appimageTools,
  runCommand,
  curl,
  gnugrep,
  cacert,
}:

appimageTools.wrapType1 rec {
  pname = "pureref";
  version = "2.0.3";

  src =
    runCommand "PureRef-${version}_x64.Appimage"
      {
        nativeBuildInputs = [
          curl
          gnugrep
          cacert
        ];
        outputHash = "sha256-0iR1cP2sZvWWqKwRAwq6L/bmIBSYHKrlI8u8V2hANfM=";
      }
      ''
        key="$(curl -A 'nixpkgs/Please contact maintainer if there is an issue' "https://www.pureref.com/download.php" --silent | grep '%3D%3D' | cut -d '"' -f2)"
        curl -L "https://www.pureref.com/files/build.php?build=LINUX64.Appimage&version=${version}&downloadKey=$key" --output $out
      '';

  meta = {
    description = "Reference Image Viewer";
    homepage = "https://www.pureref.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      elnudev
      husjon
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
