{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  writeShellApplication,
  curl,
  cacert,
  gnugrep,
  common-updater-scripts,
  versionCheckHook,
  writeShellScript,
  xcbuild,
  coreutils,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rapidapi";
  version = "4.4.3-4004003001";

  src = fetchurl {
    url = "https://cdn-builds.paw.cloud/paw/RapidAPI-${finalAttrs.version}.zip";
    hash = "sha256-eckLVX/NnyYa2Ad1+D6RUxR6nGrRcG5HFkudhFWhII0=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;
  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = "RapidAPI.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    unzip -d $out/Applications $src

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "rapidapi-update-script";
    runtimeInputs = [
      curl
      cacert
      gnugrep
      common-updater-scripts
    ];
    text = ''
      url="https://paw.cloud/download"
      version=$(curl -Ls -o /dev/null -w "%{url_effective}" "$url" | grep -oP '\d+\.\d+\.\d+-\d+')
      update-source-version rapidapi "$version"
    '';
  });

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = writeShellScript "version-check" ''
    marketing_version=$(${xcbuild}/bin/PlistBuddy -c "Print :CFBundleShortVersionString" "$1" | ${coreutils}/bin/tr -d '"')
    build_version=$(${xcbuild}/bin/PlistBuddy -c "Print :CFBundleVersion" "$1")
    echo $marketing_version-$build_version
  '';
  versionCheckProgramArg = [ "${placeholder "out"}/Applications/RapidAPI.app/Contents/Info.plist" ];
  doInstallCheck = true;

  meta = {
    description = "Full-featured HTTP client that lets you test and describe the APIs you build or consume";
    homepage = "https://paw.cloud";
    changelog = "https://paw.cloud/updates/${lib.head (lib.splitString "-" finalAttrs.version)}";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
