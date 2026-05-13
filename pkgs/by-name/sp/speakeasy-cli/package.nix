{
  lib,
  stdenv,
  fetchurl,
  unzip,
  curl,
  jq,
  installShellFiles,
  writeShellScript,
  common-updater-scripts,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "speakeasy-cli";
  version = "1.636.3";

  sourceRoot = ".";
  src =
    finalAttrs.passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported System: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    unzip
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall
    install -Dm 755 ./speakeasy $out/bin/speakeasy
    runHook postInstall
  '';

  passthru = {
    sources = {
      "x86_64-darwin" = fetchurl {
        url = "https://github.com/speakeasy-api/speakeasy/releases/download/v${finalAttrs.version}/speakeasy_darwin_amd64.zip";
        hash = "sha256-Q1m4g5XBNAaxJZyYz6cD/7asTUGZMa493XVVJ9s0byE=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://github.com/speakeasy-api/speakeasy/releases/download/v${finalAttrs.version}/speakeasy_linux_amd64.zip";
        hash = "sha256-H1c+b4/fBWudc3tAHTNdWwa9aoe8HpffRaLRU7OOWs4=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://github.com/speakeasy-api/speakeasy/releases/download/v${finalAttrs.version}/speakeasy_darwin_arm64.zip";
        hash = "sha256-xO9S9gjiMel2ZB8Dq2nN5O+zIB/4qf5Z2xeXS0wiprc=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://github.com/speakeasy-api/speakeasy/releases/download/v${finalAttrs.version}/speakeasy_linux_arm64.zip";
        hash = "sha256-zH/HyA6MrrCh9j53hoqfVSiRqIoL6IOCV/nsAwRlgjg=";
      };
    };
    updateScript = writeShellScript "update-speakeasy" ''
      set -o errxt
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"

      NEW_VERSION=$(curl --silent https://api.github.com/repos/speakeasy-api/speakeasy/releases/latest | jq '.tag_name' | ltrimstr("v") --raw-output)
      if [[ ${finalAttrs.version} = "$NEW_VERSION"]]; then
        echo "The new version is the same as old"
        exit 0
      fi
      for platfrom in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        update-source-version "speakeasy-cli" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
    '';
  };

  meta = {
    description = "CLI tool for Speakeasy";
    homepage = "https://www.speakeasyapi.dev/";
    changelog = "https://github.com/speakeasy-api/speakeasy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.elastic20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      eveeifyeve
    ];
    mainProgram = "speakeasy";
    platforms = builtins.attrNames finalAttrs.passthru.sources;
  };
})
