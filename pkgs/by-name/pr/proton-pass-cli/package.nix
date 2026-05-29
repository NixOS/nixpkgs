{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  curl,
  common-updater-scripts,
  jq,
  keyutils,
  libgcc,
  makeBinaryWrapper,
  versionCheckHook,
  writeShellScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proton-pass-cli";
  version = "2.1.0";

  src = finalAttrs.passthru.sources.${stdenv.hostPlatform.system};

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    keyutils
    libgcc
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/pass-cli

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/pass-cli --set PROTON_PASS_NO_UPDATE_CHECK 1
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    sources = {
      "aarch64-darwin" = fetchurl {
        url = "https://proton.me/download/pass-cli/${finalAttrs.version}/pass-cli-macos-aarch64";
        hash = "sha256-5FQSl6Xqipm6MWq2kza2FVXSajX4xCB4gqaAed40NoI=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://proton.me/download/pass-cli/${finalAttrs.version}/pass-cli-linux-aarch64";
        hash = "sha256-4UgcR9yV/iQaQoQUFDRa+yzSCFIIk/SaPCOJdTgpMQI=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://proton.me/download/pass-cli/${finalAttrs.version}/pass-cli-macos-x86_64";
        hash = "sha256-iT53cCskSY8+AvLXWQGcqFklQJJBO1d7AFMEIYEDllo=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://proton.me/download/pass-cli/${finalAttrs.version}/pass-cli-linux-x86_64";
        hash = "sha256-WnddX4Ov+9jBvL8VF8ONGhV8FgEz5xNrANUxG6/oupM=";
      };
    };
    updateScript = writeShellScript "update-proton-pass-cli" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent https://proton.me/download/pass-cli/versions.json | jq '.passCliVersions.version' --raw-output)
      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
          echo "No update available."
          exit 0
      fi
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        update-source-version "proton-pass-cli" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  meta = {
    description = "Command-line interface for managing your Proton Pass vaults, items, and secrets";
    homepage = "https://github.com/protonpass/pass-cli";
    license = lib.licenses.unfree;
    mainProgram = "pass-cli";
    maintainers = with lib.maintainers; [ delafthi ];
    platforms = lib.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
