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
  version = "1.0.34+165650.2dc581466117";
  encodedVersion = builtins.replaceStrings [ "+" ] [ "%2B" ] version;
  platformSuffix = if stdenvNoCC.hostPlatform.isAarch64 then "arm64" else "amd64";
  osName = if stdenvNoCC.hostPlatform.isDarwin then "darwin" else "linux";

  sources = {
    "x86_64-linux" = {
      url = "https://sfc-repo.snowflakecomputing.com/cortex-code-cli/a4643c4278/${encodedVersion}/coco-${encodedVersion}-linux-amd64.tar.gz";
      hash = "sha256-5v/rRqp+kzvqj2IxdPhnlC7pOd9BGxsYZp3Rhkt1pX0=";
    };
    "aarch64-linux" = {
      url = "https://sfc-repo.snowflakecomputing.com/cortex-code-cli/a4643c4278/${encodedVersion}/coco-${encodedVersion}-linux-arm64.tar.gz";
      hash = "sha256-D78MILDTrrVxdiKtTyUkcxKGQ7zyn2wh4GHlUHZWElQ=";
    };
    "x86_64-darwin" = {
      url = "https://sfc-repo.snowflakecomputing.com/cortex-code-cli/a4643c4278/${encodedVersion}/coco-${encodedVersion}-darwin-amd64.tar.gz";
      hash = "sha256-OkeQcn6aUTzaIR6gxHFcWiJqTmm+UKCrQLX2L6LsEUE=";
    };
    "aarch64-darwin" = {
      url = "https://sfc-repo.snowflakecomputing.com/cortex-code-cli/a4643c4278/${encodedVersion}/coco-${encodedVersion}-darwin-arm64.tar.gz";
      hash = "sha256-93NZ6ZwZDByI6LsJSyyt/3kD3j+5g9ZQEoqs+3UJ5QY=";
    };
  };
in
stdenvNoCC.mkDerivation {
  pname = "cortex-code";
  inherit version;

  src = fetchurl sources.${stdenvNoCC.hostPlatform.system};

  sourceRoot = "coco-${version}-${osName}-${platformSuffix}";

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    icu
  ];

  # Not compiling from source, unpacking resources
  dontBuild = true;
  dontConfigure = true;

  # Stripping breaks the upstream cortex binary behavior and would launch as simply 'bun'
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/cortex-code

    cp -r ./* $out/lib/cortex-code/

    # Create wrapper for main binary
    makeWrapper $out/lib/cortex-code/cortex $out/bin/cortex

    # Link additional binaries when bundled upstream
    if [ -e $out/lib/cortex-code/browser ]; then
      ln -s $out/lib/cortex-code/browser $out/bin/cortex-browser
    fi

    if [ -e $out/lib/cortex-code/fdbt ]; then
      ln -s $out/lib/cortex-code/fdbt $out/bin/cortex-fdbt
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cortex Code - Snowflake's CLI for Claude";
    homepage = "https://ai.snowflake.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ randoneering ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "cortex";
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
