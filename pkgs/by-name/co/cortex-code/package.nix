{
  lib,
  stdenvNoCC,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  icu,
}:
let
  version = "1.0.50+181048.6ef165b94127";
  encodedVersion = lib.replaceString "+" "%2B" version;
  hostPlatform = stdenvNoCC.hostPlatform;
  platformSuffix = if hostPlatform.isAarch64 then "arm64" else "amd64";
  osName =
    if hostPlatform.isDarwin then
      "darwin"
    else if hostPlatform.isLinux then
      "linux"
    else
      throw "Unsupported platform: ${hostPlatform.system}";

  sources = {
    "x86_64-linux" = {
      url = "https://sfc-repo.snowflakecomputing.com/cortex-code-cli/a4643c4278/${encodedVersion}/coco-${encodedVersion}-linux-amd64.tar.gz";
      hash = "sha256-x43lNx43xAuP8pABdM9kUNsQTTaDje+2/ySTz33e7ro=";
    };
    "aarch64-linux" = {
      url = "https://sfc-repo.snowflakecomputing.com/cortex-code-cli/a4643c4278/${encodedVersion}/coco-${encodedVersion}-linux-arm64.tar.gz";
      hash = "sha256-LsgZp9FCD2TMBgV7mP+mxE+KdTTfgCh3SILtSjwFg/g=";
    };
    "x86_64-darwin" = {
      url = "https://sfc-repo.snowflakecomputing.com/cortex-code-cli/a4643c4278/${encodedVersion}/coco-${encodedVersion}-darwin-amd64.tar.gz";
      hash = "sha256-slXZuRUfeXa/LohFPf02DBAy2ME680Mr1g7vwu9Vjoo=";
    };
    "aarch64-darwin" = {
      url = "https://sfc-repo.snowflakecomputing.com/cortex-code-cli/a4643c4278/${encodedVersion}/coco-${encodedVersion}-darwin-arm64.tar.gz";
      hash = "sha256-4GxuFi8dKuajbR2jhD3s1dayW4GmTbv3+ydlDI/m2MU=";
    };
  };
in
stdenvNoCC.mkDerivation {
  pname = "cortex-code";
  inherit version;

  __structuredAttrs = true;

  src = fetchurl sources.${hostPlatform.system};

  sourceRoot = "coco-${version}-${osName}-${platformSuffix}";

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals hostPlatform.isLinux [
    stdenv.cc.cc.lib
    icu
  ];

  # Stripping breaks the upstream cortex binary behavior and would launch as simply 'bun'
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/cortex-code

    cp -r ./* $out/lib/cortex-code/

    makeWrapper $out/lib/cortex-code/cortex $out/bin/cortex
  ''
  + lib.optionalString (hostPlatform.system == "x86_64-linux" || hostPlatform.isDarwin) ''
    ln -s $out/lib/cortex-code/fdbt $out/bin/cortex-fdbt
  ''
  + ''

    runHook postInstall
  '';

  meta = {
    description = "Cortex Code - Snowflake's Coding Agent";
    homepage = "https://ai.snowflake.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ randoneering ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "cortex";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
