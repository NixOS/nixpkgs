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
  version = "1.4.1";

  src = finalAttrs.passthru.sources.${stdenv.hostPlatform.system};

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
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

  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/pass-cli";
  versionCheckProgramArg = "--version";

  passthru = {
    sources = {
      "aarch64-darwin" = fetchurl {
        url = "https://proton.me/download/pass-cli/${finalAttrs.version}/pass-cli-macos-aarch64";
        hash = "sha256-cBkFD0kNgonAReyjmmq/P9SA9rzD+ngHgxJBtOwT1/E=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://proton.me/download/pass-cli/${finalAttrs.version}/pass-cli-linux-aarch64";
        hash = "sha256-KPSrJbDqIVyV6H1NV8JJn+gJrKbpVFEE7AiZWXOqg60=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://proton.me/download/pass-cli/${finalAttrs.version}/pass-cli-macos-x86_64";
        hash = "sha256-zv+lR9FK+Opazwlj8R7w1g7gvTf9ftNKTHDvhtgq0DU=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://proton.me/download/pass-cli/${finalAttrs.version}/pass-cli-linux-x86_64";
        hash = "sha256-DGQs34QYbOUISZW3ECnA+7d5VCgjK+q42HQZN/23Jks=";
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
