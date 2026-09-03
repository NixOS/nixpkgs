{
  autoPatchelfHook,
  fetchzip,
  glib,
  lib,
  libxcb,
  microsoft-edge,
  nspr,
  nss,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "msedgedriver";
  version = "152.0.4191.53";

  src = fetchzip {
    url = "https://msedgedriver.microsoft.com/${finalAttrs.version}/edgedriver_linux64.zip";
    hash = "sha256-3akRs0D76LAJ8Lgr3P7X+cDrMNXiEC+LWNH8lUdBM9k=";
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
    maintainers = microsoft-edge.meta.maintainers;
    platforms = [
      "x86_64-linux"
    ];
    mainProgram = "msedgedriver";
  };
})
