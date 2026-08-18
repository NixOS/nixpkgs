{
  lib,
  meta,
  stdenvNoCC,
  _7zz,
  fetchurl,
  writeShellScript,
  coreutils,
  curl,
  xmlstarlet,
  common-updater-scripts,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-vpn";
  version = "6.5.1";

  src = fetchurl {
    url = "https://protonvpn.com/download/macos/${finalAttrs.version}/ProtonVPN_mac_v${finalAttrs.version}.dmg";
    hash = "sha256-1QpJ8UxQsO+K1oqJ/JaF1WmbotT5LLTDQxcpG0JUNfg=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  sourceRoot = ".";

  nativeBuildInputs = [ _7zz ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R ./ProtonVPN/ProtonVPN.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = writeShellScript "proton-vpn-update-script" ''
    set -euo pipefail
    export PATH="${
      lib.makeBinPath [
        curl
        xmlstarlet
        common-updater-scripts
        coreutils
      ]
    }"

    xml=$(curl -s "https://protonvpn.com/download/macos/updates/v5/sparkle.xml")

    version=$(echo "$xml" | xmlstarlet sel -t -v '//enclosure/@sparkle:shortVersionString' | head -1)

    update-source-version proton-vpn "$version" --file=./pkgs/by-name/pr/proton-vpn/darwin.nix
  '';

  meta = meta // {
    platforms = [
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
