{
  lib,
  stdenvNoCC,
  fetchurl,
  gzip,
  xar,
  cpio,
  writeShellApplication,
  curl,
  cacert,
  gawk,
  common-updater-scripts,
  versionCheckHook,
  writeShellScript,
  re-plistbuddy,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "enpass-mac";
  version = "6.12.7.2787";

  src = fetchurl {
    url = "https://dl.enpass.io/stable/mac/package/${finalAttrs.version}/Enpass.pkg";
    hash = "sha256-99U/7FgmK7aHSbKniktg8SXnL7pvX/Qzzo2iAOvq1A8=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [
    gzip
    xar
    cpio
  ];

  unpackPhase = ''
    runHook preUnpack

    xar -xf $src
    gunzip -dc Enpass_temp.pkg/Payload > decompressed.out
    cat decompressed.out | cpio -it | grep -v '/._' > file-list-no-resource-forks.txt
    cat decompressed.out | cpio -i -E file-list-no-resource-forks.txt

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv Enpass.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "enpass-mac-update-script";
    runtimeInputs = [
      curl
      cacert
      gawk
      common-updater-scripts
    ];
    text = ''
      userAgent="Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0"
      url="https://www.enpass.io/download/macos/website/stable"
      version=$(curl -Lsf --user-agent "$userAgent" -o /dev/null -w "%{url_effective}" "$url" | awk -F'/' '{print $7}')
      update-source-version enpass-mac "$version"
    '';
  });

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = writeShellScript "version-check" ''
    marketing_version=$(${lib.getExe' re-plistbuddy "PlistBuddy"} -c "Print :CFBundleShortVersionString" "$1")
    build_version=$(${lib.getExe' re-plistbuddy "PlistBuddy"} -c "Print :CFBundleVersion" "$1")

    echo $marketing_version.$build_version
  '';
  versionCheckProgramArg = [ "${placeholder "out"}/Applications/Enpass.app/Contents/Info.plist" ];
  doInstallCheck = true;

  meta = {
    description = "Choose your own safest place to store passwords";
    homepage = "https://www.enpass.io";
    changelog = "https://www.enpass.io/release-notes/macos-website-ver/";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    platforms = lib.platforms.darwin;
  };
})
