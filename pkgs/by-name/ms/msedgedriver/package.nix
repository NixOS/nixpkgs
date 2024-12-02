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
  # finding a version that has all 4 builds is a pain
  # https://msedgewebdriverstorage.z22.web.core.windows.net/?form=MA13LH
  version = "130.0.2849.1";

  src =
    let
      inherit (stdenvNoCC.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "linux64";
        aarch64-linux = "arm64";
        x86_64-darwin = "mac64";
        aarch64-darwin = "mac64_m1";
      };

      hash = selectSystem {
        x86_64-linux = "sha256-U6YGD2PAhVUa7f+R5pmKLazGLOBbf3bRqzlwIJewA+w=";
        aarch64-linux = "sha256-QJ1jRw8kkWbT8US5qI8DMZI/7Q8yJWpFXrfzGdxDWKE=";
        x86_64-darwin = "sha256-Ejcv1DtuEiLJvTsv48AwoCQlFO3xM9PkM3HvZG65AC4=";
        aarch64-darwin = "sha256-ykn4bYREE6xmJY02WiCRGsGnyWjnmnZM8FemK4XZqhc=";
      };
    in
    fetchzip {
      url = "https://msedgedriver.azureedge.net/${finalAttrs.version}/edgedriver_${suffix}.zip";
      inherit hash;
      stripRoot = false;
    };

  buildInputs = [
    glib
    libxcb
    nspr
    nss
  ];

  nativeBuildInputs = lib.optionals (!stdenvNoCC.hostPlatform.isDarwin) [ autoPatchelfHook ];

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
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "msedgedriver";
  };
})
