{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  common-updater-scripts,
  curl,
  installShellFiles,
  jq,
  unzip,
  testers,
  writeShellScript,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "1.0.10";

  src =
    finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
  sourceRoot = ".";

  strictDeps = true;
  nativeBuildInputs = [
    unzip
    installShellFiles
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm 755 ./opencode $out/bin/opencode

    runHook postInstall
  '';

  passthru = {
    sources = {
      "aarch64-darwin" = fetchurl {
        url = "https://github.com/sst/opencode/releases/download/v${finalAttrs.version}/opencode-darwin-arm64.zip";
        hash = "sha256-D34OcJgIXVkqDOf5Vyce30v5/avDKKYbOAcMWD8HmXM=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://github.com/sst/opencode/releases/download/v${finalAttrs.version}/opencode-linux-arm64.zip";
        hash = "sha256-v3j0oL2WL4DezOxdEKgOq4f8BkdR01zlYHUzbUUjgtE=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://github.com/sst/opencode/releases/download/v${finalAttrs.version}/opencode-darwin-x64.zip";
        hash = "sha256-+kycX2mbCy7p6VOKO9HequCoJi/5nT8Pf09obZEuj1E=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://github.com/sst/opencode/releases/download/v${finalAttrs.version}/opencode-linux-x64.zip";
        hash = "sha256-MO8IeCnrTUyNroY7T7XY4WCXP8wgI3r4PxhfGwprh9I=";
      };
    };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "HOME=$(mktemp -d) opencode --version";
      inherit (finalAttrs) version;
    };
    updateScript = writeShellScript "update-opencode" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent https://api.github.com/repos/sst/opencode/releases/latest | jq '.tag_name | ltrimstr("v")' --raw-output)
      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
          echo "No update available."
          exit 0
      fi
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        update-source-version "opencode" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  meta = {
    description = "AI coding agent built for the terminal";
    changelog = "https://github.com/sst/opencode/releases/tag/v${finalAttrs.version}";
    longDescription = ''
      OpenCode is a terminal-based agent that can build anything.
      It combines a TypeScript/JavaScript core with a Go-based TUI
      to provide an interactive AI coding experience.
    '';
    homepage = "https://github.com/sst/opencode";
    license = lib.licenses.mit;
    platforms = builtins.attrNames finalAttrs.passthru.sources;
    maintainers = with lib.maintainers; [
      zestsystem
      delafthi
    ];
    mainProgram = "opencode";
  };
})
