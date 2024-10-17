{
  autoPatchelfHook,
  fetchurl,
  glib,
  lib,
  nspr,
  nss,
  stdenv,
  unzip,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "msedgedriver";
  version = "129.0.2792.91";

  src = fetchurl {
    url = "https://msedgedriver.azureedge.net/${finalAttrs.version}/edgedriver_linux64.zip";
    hash = "sha256-69+quFNgjioVBtsRSZDPBYXWhtCvX6cZ5TqGhhf5Ht8=";
  };

  buildInputs = [
    stdenv.cc.cc.lib
    glib
    xorg.libxcb
    nspr
    nss
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];

  installPhase = ''
    runHook preInstall
    unzip $src
    install -m777 -D "msedgedriver" $out/bin/msedgedriver
    runHook postInstall
  '';

  meta = {
    homepage = "https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver";
    description = "A WebDriver implementation that controls an Edge browser running on the local machine";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ cholli ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "msedgedriver";
  };
})
