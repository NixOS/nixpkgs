{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  makeBinaryWrapper,
  versionCheckHook,
  writeShellScript,
  re-plistbuddy,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cyberduck";
  version = "9.5.4.45528";

  src = fetchurl {
    url = "https://update.cyberduck.io/Cyberduck-${finalAttrs.version}.zip";
    hash = "sha256-k5h3etAb+scijbOZCu0cg0Q3pZlmTg8+J6aP61PLzr8=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r Cyberduck.app $out/Applications
    makeWrapper $out/Applications/Cyberduck.app/Contents/MacOS/Cyberduck $out/bin/cyberduck

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = writeShellScript "version-check" ''
    marketing_version=$(${lib.getExe' re-plistbuddy "PlistBuddy"} -c "Print :CFBundleShortVersionString" "$1")
    build_version=$(${lib.getExe' re-plistbuddy "PlistBuddy"} -c "Print :CFBundleVersion" "$1")

    echo $marketing_version.$build_version
  '';
  versionCheckProgramArg = [ "${placeholder "out"}/Applications/Cyberduck.app/Contents/Info.plist" ];
  doInstallCheck = true;

  meta = {
    description = "Libre file transfer client for Mac and Windows";
    homepage = "https://cyberduck.io";
    changelog = "https://cyberduck.io/changelog/";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      emilytrau
      DimitarNestorov
    ];
    platforms = lib.platforms.darwin;
    mainProgram = "cyberduck";
  };
})
