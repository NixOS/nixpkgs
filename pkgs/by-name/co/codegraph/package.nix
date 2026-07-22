{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  writeShellScript,
  curl,
  common-updater-scripts,
  cctools,
  darwin,
  rcodesign,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "codegraph";
  version = "0.9.9";

  src =
    finalAttrs.passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  sourceRoot =
    {
      "aarch64-darwin" = "codegraph-darwin-arm64";
      "aarch64-linux" = "codegraph-linux-arm64";
      "x86_64-darwin" = "codegraph-darwin-x64";
      "x86_64-linux" = "codegraph-linux-x64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    rcodesign
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/codegraph
    cp -r lib $out/lib/codegraph/lib
    cp node $out/lib/codegraph/node

    install -Dm 755 bin/codegraph $out/lib/codegraph/bin/codegraph

    mkdir -p $out/bin
    makeWrapper $out/lib/codegraph/bin/codegraph $out/bin/codegraph

    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    '${lib.getExe' cctools "${cctools.targetPrefix}install_name_tool"}' $out/lib/codegraph/node \
      -change /usr/lib/libicucore.A.dylib '${lib.getLib darwin.ICU}/lib/libicucore.A.dylib'
    '${lib.getExe rcodesign}' sign --code-signature-flags linker-signed $out/lib/codegraph/node
  '';

  passthru = {
    sources = {
      "aarch64-darwin" = fetchurl {
        url = "https://github.com/colbymchenry/codegraph/releases/download/v${finalAttrs.version}/codegraph-darwin-arm64.tar.gz";
        hash = "sha256-Jm7gOMUpRulu4iKEP8bz5E01E0HtmPEfUne9/OmIDKU=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://github.com/colbymchenry/codegraph/releases/download/v${finalAttrs.version}/codegraph-linux-arm64.tar.gz";
        hash = "sha256-c8bldypGnYwcs8+OuToIULDeLoAQWwoCrA/QWdEn3pk=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://github.com/colbymchenry/codegraph/releases/download/v${finalAttrs.version}/codegraph-darwin-x64.tar.gz";
        hash = "sha256-tYPq7T5Ou0/tPGsI47H3j3v2Z8WAQVU9aWIpsh4+nxE=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://github.com/colbymchenry/codegraph/releases/download/v${finalAttrs.version}/codegraph-linux-x64.tar.gz";
        hash = "sha256-xA7oC84tNUyHS+/l7OmWKBy0bPCDAENy02/YpyOLWfs=";
      };
    };
    updateScript = writeShellScript "update-codegraph" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/colbymchenry/codegraph/releases/latest" | sed -n 's#.*/releases/tag/v##p')
      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        update-source-version "codegraph" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  meta = {
    description = "Pre-indexed code knowledge graph for AI coding agents";
    homepage = "https://github.com/colbymchenry/codegraph";
    changelog = "https://github.com/colbymchenry/codegraph/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "codegraph";
    maintainers = [ lib.maintainers.gdifolco ];
    platforms = builtins.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
