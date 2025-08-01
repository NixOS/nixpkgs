{
  lib,
  appimageTools,
  makeWrapper,
  runCommand,
  curl,
  gnugrep,
  cacert,
  dpkg,
}:
let
  version = "2.0.3";
  deb =
    runCommand "PureRef-${version}_x64"
      {
        nativeBuildInputs = [
          curl
          gnugrep
          cacert
          dpkg
        ];
        outputHash = "sha256-VdKu1YQa+//FbNWqgTPoUhY4pSekgVohI53D4i5hVkQ=";
        outputHashMode = "recursive";
      }
      ''
        key="$(curl -A 'nixpkgs/Please contact maintainer if there is an issue' "https://www.pureref.com/download.php" --silent | grep '%3D%3D' | cut -d '"' -f2)"
        curl -L "https://www.pureref.com/files/build.php?build=LINUX64.deb&version=${version}&downloadKey=$key" --output $name.deb
        dpkg-deb -x $name.deb $out
        chmod 755 $out
      '';
in
appimageTools.wrapType1 {
  pname = "pureref";
  inherit version;

  nativeBuildInputs = [ makeWrapper ];

  src = "${deb}/usr/bin/PureRef";

  extraInstallCommands = ''
    mv $out/bin/pureref $out/bin/PureRef
    cp -r ${deb}/usr/share $out
    wrapProgram $out/bin/PureRef --set QT_QPA_PLATFORM xcb
  '';

  meta = with lib; {
    description = "Reference Image Viewer";
    homepage = "https://www.pureref.com";
    license = licenses.unfree;
    maintainers = with maintainers; [
      elnudev
      husjon
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "PureRef";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
