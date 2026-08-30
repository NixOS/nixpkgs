{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
  _7zz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "passepartout";
  version = "3.8.4";

  src = fetchurl (
    {
      aarch64-darwin = {
        url = "https://github.com/partout-io/passepartout/releases/download/v3.8.4/Passepartout.arm64.dmg";
        hash = "sha256-fA+irWbORkIhfxVIx7tz6RkuQHi1I6nCOKxiLx+a+8E=";
      };
      x86_64-darwin = {
        url = "https://github.com/partout-io/passepartout/releases/download/v3.8.4/Passepartout.x86_64.dmg";
        hash = "sha256-noF3oe0GbtOXo81s69O+BsOlKSt1LVMwZmB5rf2jHrs=";
      };
    }
    .${stdenvNoCC.hostPlatform.system}
      or (throw "passepartout-3.8.4: unsupported system ${stdenvNoCC.hostPlatform.system}")
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
    changelog = "https://github.com/partout-io/passepartout/blob/master/CHANGELOG.txt";
    downloadPage = "https://github.com/partout-io/passepartout/releases";
    license = lib.licenses.gpl3Only;
    mainProgram = "passepartout";
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
