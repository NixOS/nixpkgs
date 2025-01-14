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
  coreutils,
  xcbuild,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "enpass-mac";
  version = "6.11.8.1861";

  src = fetchurl {
    url = "https://dl.enpass.io/stable/mac/package/${finalAttrs.version}/Enpass.pkg";
    hash = "sha256-n0ClsyGTS52ms161CJihIzBI5GjiMIF6HEJ59+jciq8=";
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
    gunzip -dc Enpass_temp.pkg/Payload | cpio -i

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
      url="https://www.enpass.io/download/macos/website/stable"
      version=$(curl -Ls -o /dev/null -w "%{url_effective}" "$url" | awk -F'/' '{print $7}')
      update-source-version enpass-mac "$version"
    '';
  });

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = writeShellScript "version-check" ''
    marketing_version=$(${xcbuild}/bin/PlistBuddy -c "Print :CFBundleShortVersionString" "$1" | ${coreutils}/bin/tr -d '"')
    build_version=$(${xcbuild}/bin/PlistBuddy -c "Print :CFBundleVersion" "$1")

    echo $marketing_version.$build_version
  '';
  versionCheckProgramArg = [ "${placeholder "out"}/Applications/Enpass.app/Contents/Info.plist" ];
  doInstallCheck = true;

  meta = {
    description = "Choose your own safest place to store passwords";
    homepage = "https://www.enpass.io";
    changelog = "https://www.enpass.io/release-notes/macos-website-ver/";
    license = [ lib.licenses.unfree ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    platforms = lib.platforms.darwin;
  };
})
