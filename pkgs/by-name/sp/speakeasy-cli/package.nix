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
  version = "1.736.1";

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
        hash = "sha256-MCMqS4kRGy+U5z2mUK3rJKKma6IpsQq1cvWgzJhDwnk=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://github.com/speakeasy-api/speakeasy/releases/download/v${finalAttrs.version}/speakeasy_linux_amd64.zip";
        hash = "sha256-daW3jKpy+aYFpOOTwNwr3UCRLKkd3zInQBUHswYk3rU=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://github.com/speakeasy-api/speakeasy/releases/download/v${finalAttrs.version}/speakeasy_darwin_arm64.zip";
        hash = "sha256-otZqYbiJeJNiKEjXgJy/eLBjZ8+nyKQf1O9GAJZwgrA=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://github.com/speakeasy-api/speakeasy/releases/download/v${finalAttrs.version}/speakeasy_linux_arm64.zip";
        hash = "sha256-+SYqBYD7fhEMqleMIUnygsfI8c6u09ugeed7lrPPcYU=";
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

                NEW_VERSION=$(curl --silent https://api.github.com/repos/speakeasy-api/speakeasy/releases/latest | jq --raw-output '.tag_name | ltrimstr("v")')
          if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
                  echo "The new version is the same as old"
                  exit 0
                fi
      for platform in ${lib.escapeShellArgs (builtins.attrNames finalAttrs.passthru.sources)}; do
        update-source-version "speakeasy-cli" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
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
