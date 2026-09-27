{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  versionCheckHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "omac";
  version = "1.4.7";

  __structuredAttrs = true;
  strictDeps = true;

  # fetchurl rather than fetchzip: the hash is then the one the release publishes
  # in Omac-arm64.zip.sha256. The asset has the same name in every release.
  src = fetchurl {
    url = "https://github.com/evanscastonguay/omac/releases/download/v${finalAttrs.version}/Omac-arm64.zip";
    hash = "sha256-oGSu7n8T8KIyB7EZoFAywc0BAPkVzrbOeX4Dhu3h2S4=";
  };

  nativeBuildInputs = [ unzip ];

  # The archive holds Omac-<version>-arm64/ next to a __MACOSX/ folder of
  # AppleDouble files, which carry only com.apple.provenance.
  sourceRoot = "Omac-${finalAttrs.version}-arm64";

  # The bundle is installed byte for byte. It is signed with a Developer ID, and
  # macOS ties the Accessibility permission a window manager needs to that
  # signature: stripping or patching anything inside would break the seal.
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    cp -R Omac.app "$out/Applications/"
    ln -s "$out/Applications/Omac.app/Contents/Helpers/omac" "$out/bin/omac"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keyboard-driven tiling window manager for macOS with Omarchy's keybindings";
    homepage = "https://github.com/evanscastonguay/omac";
    changelog = "https://github.com/evanscastonguay/omac/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ lib.maintainers.evanscastonguay ];
    platforms = [ "aarch64-darwin" ];
    mainProgram = "omac";
  };
})
