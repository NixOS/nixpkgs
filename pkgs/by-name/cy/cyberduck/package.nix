{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  makeBinaryWrapper,
  versionCheckHook,
  writeShellScript,
  coreutils,
  xcbuild,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cyberduck";
  version = "9.2.4.43667";

  src = fetchurl {
    url = "https://update.cyberduck.io/Cyberduck-${finalAttrs.version}.zip";
    hash = "sha256-fTJoNdgp6EWdloejk7XG2lJh1NErxFRmvx2fZiwvWuc=";
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
    marketing_version=$(${xcbuild}/bin/PlistBuddy -c "Print :CFBundleShortVersionString" "$1" | ${coreutils}/bin/tr -d '"')
    build_version=$(${xcbuild}/bin/PlistBuddy -c "Print :CFBundleVersion" "$1")

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
      iedame
    ];
    platforms = lib.platforms.darwin;
    mainProgram = "cyberduck";
  };
})
