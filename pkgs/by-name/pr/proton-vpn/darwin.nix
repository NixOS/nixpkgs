{
  lib,
  meta,
  stdenvNoCC,
  _7zz,
  fetchurl,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-vpn";
  version = "6.5.0";

  src = fetchurl {
    url = "https://github.com/ProtonVPN/ios-mac-app/releases/download/mac%2F${finalAttrs.version}/ProtonVPN_mac_v${finalAttrs.version}.dmg";
    hash = "sha256-lB44pIA5AxdcYQ/iccWcqJDOrQkVLRVl0vy1HuPPl8o=";
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "mac/(.*)"
    ];
  };

  meta = meta // {
    changelog = "https://github.com/ProtonVPN/ios-mac-app/releases/tag/mac%2F${finalAttrs.version}";
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
