{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  versionCheckHook,
  writeShellScript,
  re-plistbuddy,
  writeShellApplication,
  cacert,
  common-updater-scripts,
  curl,
  jq,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rockxy";
  version = "0.36.0+53";

  __structuredAttrs = true;
  strictDeps = true;

  src =
    let
      versionParts = lib.splitString "+" finalAttrs.version;
      releaseVersion = lib.elemAt versionParts 0;
      buildVersion = lib.elemAt versionParts 1;
    in
    fetchurl {
      url = "https://github.com/RockxyApp/Rockxy/releases/download/v${releaseVersion}/Rockxy-${releaseVersion}-${buildVersion}.dmg";
      hash = "sha256-e377Im79wofk/zaXmIUnjT9t1KovgzZdypc6RZ4FNoU=";
    };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  # Rockxy's DMG uses APFS, which is unsupported by undmg.
  # Preserve symlinks and ignore Apple extended-attribute streams so they are
  # not extracted as files that would invalidate the signed app bundle.
  unpackCmd = "7zz x -snld -xr'!*:com.apple.*' $curSrc";

  nativeBuildInputs = [ _7zz ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R Rockxy.app "$out/Applications/"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = writeShellScript "rockxy-version-check" ''
    shortVersion="$(${lib.getExe' re-plistbuddy "PlistBuddy"} -c "Print :CFBundleShortVersionString" "$1")"
    buildVersion="$(${lib.getExe' re-plistbuddy "PlistBuddy"} -c "Print :CFBundleVersion" "$1")"
    printf '%s+%s\n' "$shortVersion" "$buildVersion"
  '';
  versionCheckProgramArg = [
    "${placeholder "out"}/Applications/Rockxy.app/Contents/Info.plist"
  ];
  doInstallCheck = true;

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "rockxy-update-script";
    runtimeInputs = [
      cacert
      common-updater-scripts
      curl
      jq
    ];
    text = ''
      metadata="$(curl --fail --silent --show-error \
        https://raw.githubusercontent.com/RockxyApp/Rockxy/main/releases/latest.json)"
      releaseVersion="$(jq --exit-status --raw-output '.version' <<< "$metadata")"
      buildVersion="$(jq --exit-status --raw-output '.build' <<< "$metadata")"
      update-source-version rockxy "$releaseVersion+$buildVersion"
    '';
  });

  meta = {
    description = "Native macOS HTTP/S and WebSocket debugging proxy";
    homepage = "https://rockxy.io/";
    changelog = "https://github.com/RockxyApp/Rockxy/releases/tag/v${lib.elemAt (lib.splitString "+" finalAttrs.version) 0}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ locnguyenhuu ];
    platforms = [ "aarch64-darwin" ];
    hydraPlatforms = [ ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
