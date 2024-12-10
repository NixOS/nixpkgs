{
  stdenvNoCC,
  lib,
  fetchurl,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "daytona-bin";
  version = "0.12.0";

  src =
    let
      urls = {
        "x86_64-linux" = {
          url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-linux-amd64";
          hash = "sha256-5nUWeIAKUSrbEAzo1SCSrebKvt2DKB/f2JZZ9c2vjxA=";
        };
        "x86_64-darwin" = {
          url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-darwin-amd64";
          hash = "sha256-JAc9EbuZnRCX2v1UXPBF8mlqz478DtrVEk6XEICW7CU=";
        };
        "aarch64-linux" = {
          url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-linux-arm64";
          hash = "sha256-1yy3S4JRtabQBK9LzepL+CVaj+3HPuG6oJe4YdbEi6E=";
        };
        "aarch64-darwin" = {
          url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-darwin-arm64";
          hash = "sha256-x5RVx5X2PD1Yu0g0umf2ywRymqa+1EFCzuXFEVSQImw=";
        };
      };
    in
    fetchurl urls."${stdenvNoCC.hostPlatform.system}";

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/daytona
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/daytonaio/daytona/releases/tag/v${finalAttrs.version}";
    description = "The Open Source Dev Environment Manager";
    homepage = "https://github.com/daytonaio/daytona";
    license = lib.licenses.asl20;
    mainProgram = "daytona";
    maintainers = with lib.maintainers; [ osslate ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
