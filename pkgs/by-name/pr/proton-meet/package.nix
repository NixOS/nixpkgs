{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:
let
  pname = "proton-meet";
  version = "1.0.14";

  passthru = {
    sources = {
      "x86_64-linux" = fetchurl {
        url = "https://proton.me/download/meet/linux/${version}/ProtonMeet-desktop.deb";
        hash = "sha256-7j90Yk7zddMVjEnZHuHPUwMsy3Cak3uuZU7EgBlh6QM=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://proton.me/download/meet/macos/${version}/ProtonMeet-desktop.dmg";
        hash = "sha256-hkZF5hPtaTNmk6liSFzKagXSZsCI42/FG1LqTAjTxiY=";
      };
    };
    updateScript = writeShellScript "update-proton-meet" ''
      set -euo pipefail
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      # Proton lists releases as Stable before they are rolled out to everyone,
      # so only consider fully rolled out ones.
      NEW_VERSION=$(curl --fail --silent --show-error --location https://proton.me/download/meet/linux/version.json | jq --exit-status --raw-output '[.Releases[] | select(.CategoryName == "Stable" and .RolloutProportion == 1)] | max_by(.Version | split(".") | map(tonumber)) | .Version')
      # Never downgrade, e.g. while a newer release is still being rolled out.
      newer=$(jq --null-input --arg new "$NEW_VERSION" --arg old "${version}" '($new | split(".") | map(tonumber)) > ($old | split(".") | map(tonumber))')
      if [[ "$newer" != true ]]; then
          echo "No newer stable version (packaged ${version}, feed $NEW_VERSION)."
          exit 0
      fi
      for platform in ${lib.escapeShellArgs meta.platforms}; do
        update-source-version "proton-meet" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  meta = {
    description = "Desktop client for Proton's end-to-end encrypted video conferencing service";
    homepage = "https://proton.me/meet";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ WitteShadovv ];
    platforms = builtins.attrNames passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "proton-meet";
    mainDarwinApp = "Proton Meet.app";
  };
in
callPackage (if stdenv.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) {
  inherit
    pname
    version
    passthru
    meta
    ;
}
