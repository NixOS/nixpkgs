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
  version = "2.2.3";

  __structuredAttrs = true;
  strictDeps = true;

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
        hash = "sha256-gxjlrznYmXgCFOxixtHCz9x2KLsgNtuo9yr3TJpjxzI=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://proton.me/download/pass-cli/${finalAttrs.version}/pass-cli-linux-aarch64";
        hash = "sha256-NdBabzetuIJEbu81Rfg3hUVEw8BJ2A3Who/i08/qwMs=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://proton.me/download/pass-cli/${finalAttrs.version}/pass-cli-linux-x86_64";
        hash = "sha256-cYjwKnweeahg9xZq0sNPei5slhJltwZ34nBPIW3Rdtk=";
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
