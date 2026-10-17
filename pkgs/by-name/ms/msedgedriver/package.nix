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
  version = "155.0.4283.62";

  src =
    let
      driverArch =
        {
          aarch64-darwin = "mac64_m1";
          x86_64-darwin = "mac64";
          x86_64-linux = "linux64";
        }
        .${stdenvNoCC.hostPlatform.system};
    in
    fetchzip {
      url = "https://msedgedriver.microsoft.com/${finalAttrs.version}/edgedriver_${driverArch}.zip";
      hash =
        {
          mac64_m1 = "sha256-ZKxY8zypkbAk787urOwN5XaGLPumg8Ir5nZSMl74RZQ=";
          mac64 = "sha256-4X13pZ/jDs4iU1oqs/nHXYi92w5vApG+kuJ2PH1W+fw=";
          linux64 = "sha256-DvuHwh0O1QL29rUAMnmtmWPEL6hhEc1f0sRsKIUar5Q=";
        }
        .${driverArch};
      stripRoot = false;
    };

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    glib
    libxcb
    nspr
    nss
  ];

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    install -D msedgedriver $out/bin/msedgedriver

    runHook postInstall
  '';

  meta = {
    homepage = "https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver";
    description = "WebDriver implementation that controls an Edge browser running on the local machine";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = microsoft-edge.meta.maintainers;
    platforms = lib.platforms.darwin ++ [
      "x86_64-linux"
    ];
    mainProgram = "msedgedriver";
  };
})
