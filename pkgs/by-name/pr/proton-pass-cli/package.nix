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
  versionCheckHook,
  writeShellScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proton-pass-cli";
  version = "1.2.0";

  src = finalAttrs.passthru.sources.${stdenv.hostPlatform.system};

  unpackPhase = ''
    runHook preUnpack

    cp $src ./pass-cli

    runHook postUnpack
  '';

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    libgcc
  ];

  buildInputs = [
    keyutils
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ./pass-cli $out/bin/pass-cli

    runHook postInstall
  '';

  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/pass-cli";
  versionCheckProgramArg = "--version";

  passthru = {
    sources = {
      "aarch64-darwin" = fetchurl {
        url = "https://proton.me/download/pass-cli/${finalAttrs.version}/pass-cli-macos-aarch64";
        hash = "sha256-ZYPwbwk90tDlqWUZr5pFEnhfLDwXULyGbcbWNU0xwnk=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://proton.me/download/pass-cli/${finalAttrs.version}/pass-cli-linux-aarch64";
        hash = "sha256-lEmdVPgtjr5hk0FVzCpntMv9HG1tPObIAM0mALbFA9w=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://proton.me/download/pass-cli/${finalAttrs.version}/pass-cli-macos-x86_64";
        hash = "sha256-qiAqr9GNqs+OqpOlMWeSW49oEhJgU4fVgfghqjnxMr8=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://proton.me/download/pass-cli/${finalAttrs.version}/pass-cli-linux-x86_64";
        hash = "sha256-x9vdFucgezmhb205OPrSO7IVQ0HjNzpHGAxoYEUmBj4=";
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
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
