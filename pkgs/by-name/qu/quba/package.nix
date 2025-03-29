{
  lib,
  stdenvNoCC,
  appimageTools,
  fetchurl,
  _7zz,
}:

let
  pname = "quba";
  version = "1.4.2";

  meta = {
    description = "Viewer for electronic invoices";
    homepage = "https://github.com/ZUGFeRD/quba-viewer";
    downloadPage = "https://github.com/ZUGFeRD/quba-viewer/releases";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ onny ];
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
  };

  src = fetchurl {
    url = "https://github.com/ZUGFeRD/quba-viewer/releases/download/v${version}/Quba-${version}.AppImage";
    hash = "sha256-3goMWN5GeQaLJimUKbjozJY/zJmqc9Mvy2+6bVSt1p0=";
  };

  appimageContents = appimageTools.extractType1 { inherit pname version src; };

  linux = appimageTools.wrapType1 {
    inherit
      pname
      version
      src
      meta
      ;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/quba.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/quba.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=quba'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  };

  darwin = stdenvNoCC.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      url = "https://github.com/ZUGFeRD/quba-viewer/releases/download/v${version}/Quba-${version}-universal.dmg";
      hash = "sha256-q7va2D9AT0BoPhfkub/RFQxGyF12uFaCDpSYIxslqMc=";
    };

    unpackCmd = "7zz x -bd -osource -xr'!*/Applications' -xr'!*com.apple.provenance' $curSrc";

    nativeBuildInputs = [ _7zz ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      mv Quba.app $out/Applications

      runHook postInstall
    '';
  };
in
if stdenvNoCC.hostPlatform.isLinux then linux else darwin
