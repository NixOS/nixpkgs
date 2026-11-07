{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
  _7zz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "passepartout";
  version = "3.12.2";

  src = fetchurl (
    {
      aarch64-darwin = {
        url = "https://github.com/partout-io/passepartout/releases/download/v${finalAttrs.version}/Passepartout.arm64.dmg";
        hash = "sha256-92F/GCl8fvrPIaaiTepdPeR2iQruYEslqJTavR9SNEU=";
      };
      x86_64-darwin = {
        url = "https://github.com/partout-io/passepartout/releases/download/v${finalAttrs.version}/Passepartout.x86_64.dmg";
        hash = "sha256-xHX2/EcvvI7AgZCDGI0xDJys3npLMyjDqXLLPeg8t/0=";
      };
    }
    .${stdenvNoCC.hostPlatform.system}
      or (throw "passepartout-${finalAttrs.version}: unsupported system ${stdenvNoCC.hostPlatform.system}")
  );

  sourceRoot = ".";

  # Fetching from source, as requires Swift 6 compiler
  # TODO: Switch to from-source build, targeting all platforms, when Swift 6 lands.
  dontBuild = true;

  nativeBuildInputs = [ _7zz ];

  # APFS format is unsupported by undmg.
  # Avoid extracting macOS extended attributes as files inside the app bundle.
  unpackCmd = "7zz x -snld -xr'!*:com.apple.*' $curSrc";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    cp -R Passepartout.app "$out/Applications"
    ln -s "$out/Applications/Passepartout.app/Contents/MacOS/Passepartout" "$out/bin/passepartout"

    runHook postInstall
  '';

  __structuredAttrs = true;
  strictDeps = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "VPN client for OpenVPN and WireGuard";
    longDescription = ''
      Passepartout is a VPN client for Apple platforms with support for
      OpenVPN, WireGuard, on-demand rules, custom DNS and proxy settings,
      custom routing, and provider presets.
    '';
    homepage = "https://passepartoutvpn.app/";
    changelog = "https://github.com/partout-io/passepartout/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/partout-io/passepartout/releases";
    license = lib.licenses.gpl3Only;
    mainProgram = "passepartout";
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
