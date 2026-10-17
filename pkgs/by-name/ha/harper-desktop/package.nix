{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
  re-plistbuddy,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "harper-desktop";
  version = "2.13.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/Automattic/harper/releases/download/v${finalAttrs.version}/Harper_${finalAttrs.version}_universal.dmg";
    hash = "sha256-Kcg+S403OrPFMnLfwSFSOzOMjg/3OdrA5ABlAYWiBUU=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    undmg
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R Harper.app "$out/Applications/"

    runHook postInstall
  '';

  # Preserve upstream's signature and notarization, which are required for
  # stable macOS Accessibility permissions.
  dontFixup = true;

  nativeInstallCheckInputs = [ re-plistbuddy ];
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    app="$out/Applications/Harper.app"
    plist="$app/Contents/Info.plist"
    bundleVersion=$(PlistBuddy -c 'Print :CFBundleShortVersionString' "$plist")
    if [[ "$bundleVersion" != "$version" ]]; then
      echo "Expected Harper version $version, found $bundleVersion" >&2
      exit 1
    fi

    executable=$(PlistBuddy -c 'Print :CFBundleExecutable' "$plist")
    test -n "$executable"
    test -x "$app/Contents/MacOS/$executable"

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Privacy-first offline grammar checker for macOS";
    longDescription = ''
      Harper Desktop provides system-wide grammar checking for macOS.
      It requires macOS 14 or later.
      Its built-in automatic updater should be disabled when installed through
      Nix; update Harper Desktop through Nixpkgs instead.
    '';
    homepage = "https://writewithharper.com/desktop";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ tyceherrman ];
    platforms = lib.platforms.darwin;
  };
})
