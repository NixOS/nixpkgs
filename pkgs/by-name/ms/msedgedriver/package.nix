{
  autoPatchelfHook,
  fetchzip,
  glib,
  lib,
  libxcb,
  nspr,
  nss,
  stdenvNoCC,

  # Since this pretty much depends on the browser having the same version we just use that version
  microsoft-edge,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "msedgedriver";
  inherit (microsoft-edge) version;

  src = fetchzip {
    url = "https://msedgedriver.azureedge.net/${finalAttrs.version}/edgedriver_linux64.zip";
    hash = "sha256-LKpTAfxvL1qhAQ5PMtl5TryodlOc0Gl14oAangqUR34=";
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
