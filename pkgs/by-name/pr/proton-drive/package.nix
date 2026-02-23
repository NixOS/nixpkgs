{
  lib,
  stdenvNoCC,
  _7zz,
  common-updater-scripts,
  curl,
  fetchurl,
  jq,
  writeShellScript,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-drive";
  version = "2.10.2";

  src = finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system};

  sourceRoot = ".";

  nativeBuildInputs = [ _7zz ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R "./Proton Drive.app" $out/Applications

    runHook postInstall
  '';

  passthru = {
    sources = {

      "aarch64-darwin" = fetchurl {
        url = "https://proton.me/download/drive/macos/${finalAttrs.version}/ProtonDrive-${finalAttrs.version}.dmg";
        hash = "sha256-0rj2ZwMJ4aHmq6QU4+Kd3SIIgxASL6eBC06/c/iJ3/Q=";
      };
      "x86_64-darwin" = finalAttrs.passthru.sources."aarch64-darwin";
    };
    updateScript = writeShellScript "update-proton-drive" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent https://proton.me/download/drive/macos/version.json | jq -r '[.Releases[] | select(.CategoryName == "Stable")] | first | .Version')
      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
          echo "The new version is the same as the old version."
          exit 0
      fi
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        update-source-version "proton-drive" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  meta = {
    description = "Official ProtonDrive app for darwin";
    homepage = "https://proton.me/drive";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ delafthi ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
