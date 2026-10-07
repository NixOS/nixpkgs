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
  version = "154.0.4258.53";

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
          mac64_m1 = "sha256-XDgJK+wT95D1zMw8FrJp1EYY57d/F5z0iLzeknU74lY=";
          mac64 = "sha256-c2YKaXQ1CESYhcenJnTSbQ13Ezkg3cfCwRvDIdPFras=";
          linux64 = "sha256-3qsuF3m5OvULklN1gcIQ0P4IcseOBgc3pftmph0T1tE=";
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
