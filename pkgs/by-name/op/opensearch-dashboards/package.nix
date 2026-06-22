{
  lib,
  stdenv,
  fetchurl,

  # nativeBuildInputs
  makeWrapper,

  # Runtime deps
  nodejs,
  coreutils,
  which,

  # updateScript
  writeShellScript,
  curl,
  common-updater-scripts,
  jq,

  # Optional override for disabling security aspects
  disableSecurity ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opensearch-dashboards";
  version = "3.6.0";

  src =
    finalAttrs.passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/libexec/opensearch-dashboards $out/bin
    mv * $out/libexec/opensearch-dashboards/
    rm -r $out/libexec/opensearch-dashboards/node
    makeWrapper $out/libexec/opensearch-dashboards/bin/opensearch-dashboards $out/bin/opensearch-dashboards \
      --prefix PATH : "${
        lib.makeBinPath [
          nodejs
          coreutils
          which
        ]
      }"
    sed -i 's@NODE=.*@NODE=${nodejs}/bin/node@' $out/libexec/opensearch-dashboards/bin/opensearch-dashboards

    ${lib.optionalString disableSecurity "rm -r $out/libexec/opensearch-dashboards/plugins/securityDashboards"}
  '';

  passthru = {
    sources = {
      "aarch64-linux" = fetchurl {
        url = "https://artifacts.opensearch.org/releases/bundle/opensearch-dashboards/${finalAttrs.version}/opensearch-dashboards-${finalAttrs.version}-linux-arm64.tar.gz";
        hash = "sha256-7FEl6q7D5Nynz/RuOyVTn6Kb/XRt8zF4OudID7LplLM=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://artifacts.opensearch.org/releases/bundle/opensearch-dashboards/${finalAttrs.version}/opensearch-dashboards-${finalAttrs.version}-linux-x64.tar.gz";
        hash = "sha256-r5Rtz1IGDbT3WmvjiBWiJYYpfMAs6VdJbhmuCE9pGi4=";
      };
    };
    updateScript = writeShellScript "update-opensearch-dashboards" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      NEW_VERSION="$(curl -s "https://api.github.com/repos/opensearch-project/opensearch-dashboards/tags" | jq -r '.[0].name')"
      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
          echo "No update available."
          exit 0
      fi
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        update-source-version "opensearch-dashboards" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    changelog = "https://github.com/opensearch-project/OpenSearch-Dashboards/blob/${finalAttrs.version}/release-notes/opensearch-dashboards.release-notes-${finalAttrs.version}.md";
    description = "Visualize logs and time-stamped data";
    downloadPage = "https://github.com/opensearch-project/OpenSearch-Dashboards";
    homepage = "https://opensearch.org/docs/latest/dashboards/index/";
    license = lib.licenses.asl20;
    mainProgram = "opensearch-dashboards";
    maintainers = with lib.maintainers; [
      makefu
      shymega
    ];
    platforms = lib.attrNames finalAttrs.passthru.sources;
  };
})
