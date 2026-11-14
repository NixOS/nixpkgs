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
  version = "157.0.4341.57";

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
          mac64_m1 = "sha256-IqW4ENYFfI5tT4AWY1i1h9wZq3X2zm/HSPRbqUF3aZQ=";
          mac64 = "sha256-8wq1hKvBY38XBMn7Zq1kT7p1qEbLnOXPXcFnBgBXY5U=";
          linux64 = "sha256-cc4B6vg4P+sUD3dm9wUxy1u4ZY2I0c/NVgOt8wruoCg=";
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
