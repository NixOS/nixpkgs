{
  autoPatchelfHook,
  fetchzip,
  glib,
  lib,
  libxcb,
  nspr,
  nss,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "msedgedriver";
  version = "148.0.3967.54";

  src = fetchzip {
    url = "https://msedgedriver.microsoft.com/${finalAttrs.version}/edgedriver_linux64.zip";
    hash = "sha256-woGkky1i9so+1D61irtJYjDQ0xoHUeGQsJi/eQ4VGhU=";
    stripRoot = false;
  };

  buildInputs = [
    glib
    libxcb
    nspr
    nss
  ];

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase =
    if stdenvNoCC.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/{Applications/msedgedriver,bin}
        cp -R . $out/Applications/msedgedriver

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        install -m777 -D "msedgedriver" $out/bin/msedgedriver

        runHook postInstall
      '';

  meta = {
    homepage = "https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver";
    description = "WebDriver implementation that controls an Edge browser running on the local machine";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ cholli ];
    platforms = [
      "x86_64-linux"
    ];
    mainProgram = "msedgedriver";
  };
})
