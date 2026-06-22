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
  pname = "proton-pass";
  version = "1.37.0";

  passthru = {
    sources = {
      "x86_64-linux" = fetchurl {
        url = "https://proton.me/download/pass/linux/x64/proton-pass_${version}_amd64.deb";
        hash = "sha256-MLJvFAKr6z0DR54gYTgwq9seb5Hk5hbOf/9SeAVxB20=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://proton.me/download/pass/macos/ProtonPass_${version}.dmg";
        hash = "sha256-EhSj3d5HsvSIpbEKKfln5niOI1B97yNxD1dg1wlZsxw=";
      };
      "x86_64-darwin" = passthru.sources."aarch64-darwin";
    };
    updateScript = writeShellScript "update-proton-pass" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent https://proton.me/download/PassDesktop/linux/x64/version.json | jq -r '[.Releases[] | select(.CategoryName == "Stable")] | first | .Version')
      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version is the same as the old version."
          exit 0
      fi
      for platform in ${lib.escapeShellArgs meta.platforms}; do
        update-source-version "proton-pass" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  meta = {
    description = "Desktop application for Proton Pass";
    homepage = "https://proton.me/pass";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      massimogengarelli
      shunueda
    ];
    platforms = builtins.attrNames passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "proton-pass";
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
