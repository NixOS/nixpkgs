{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  common-updater-scripts,
  curl,
  jq,
  writeShellScript,
}:

let
  inherit (stdenv.hostPlatform) system;

  sources = {
    "aarch64-darwin" = {
      os = "macos";
      platform = "macos-arm64";
      hash = "sha256-mBwRzk8rvD6X2kJHFp8CJs7Ga/TouU9gKXUsRMIOeFA=";
    };
    "aarch64-linux" = {
      os = "linux";
      platform = "linux-arm64";
      hash = "sha256-oU0lLDLyOMhb/odCgSfnrt7OyBrtzyEHztjqG2eUEco=";
    };
    "x86_64-linux" = {
      os = "linux";
      platform = "linux-x86-64";
      hash = "sha256-x8EiYc9+X0ZeS/MXCoSgmh4si9zbHST7RvKkrVrYYVs=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sonarqube-cli-bin";
  version = "0.11.0.1439";

  src = finalAttrs.passthru.sources.${system} or (throw "Unsupported platform ${system}");

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/sonar

    runHook postInstall
  '';

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck

    export HOME=$TMPDIR
    export SONARQUBE_CLI_DISABLE_SENTRY=1
    $out/bin/sonar --help > /dev/null

    runHook postInstallCheck
  '';

  passthru = {
    sources = lib.mapAttrs (
      _: source:
      fetchurl {
        name = "sonarqube-cli-${finalAttrs.version}-${source.platform}";
        # SonarSource publishes native platform binaries with a .exe suffix for all platforms.
        url = "https://binaries.sonarsource.com/Distribution/sonarqube-cli/${finalAttrs.version}/${source.os}/sonarqube-cli-${finalAttrs.version}-${source.platform}.exe";
        inherit (source) hash;
      }
    ) sources;

    updateScript = writeShellScript "update-sonarqube-cli-bin" ''
      set -o errexit

      export PATH="${
        lib.makeBinPath [
          common-updater-scripts
          curl
          jq
        ]
      }"

      NEW_VERSION=$(curl --silent https://api.github.com/repos/SonarSource/sonarqube-cli/releases/latest | jq --raw-output '.tag_name')
      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
        echo "The new version is the same as the old version."
        exit 0
      fi

      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        update-source-version sonarqube-cli-bin "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  meta = {
    description = "SonarQube CLI binary distribution";
    homepage = "https://github.com/SonarSource/sonarqube-cli";
    changelog = "https://github.com/SonarSource/sonarqube-cli/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ steveej ];
    mainProgram = "sonar";
    platforms = builtins.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
