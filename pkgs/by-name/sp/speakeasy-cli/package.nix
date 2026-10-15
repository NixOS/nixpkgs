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
  version = "1.800.1";

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
      "x86_64-linux" = fetchurl {
        url = "https://github.com/speakeasy-api/speakeasy/releases/download/v${finalAttrs.version}/speakeasy_linux_amd64.zip";
        hash = "sha256-0hcr8AE6Mce5hOpzk+6B4+G0dFceYXwKV1w/UneIfHs=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://github.com/speakeasy-api/speakeasy/releases/download/v${finalAttrs.version}/speakeasy_darwin_arm64.zip";
        hash = "sha256-rmuEmLhJetZbJRTus041Uv78f7UxZuxyiHqZaEp3aQ0=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://github.com/speakeasy-api/speakeasy/releases/download/v${finalAttrs.version}/speakeasy_linux_arm64.zip";
        hash = "sha256-kWSnp1YvtJUEdC55yM7fIyNunOqBjL7R0NEdZ7J0DRs=";
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
