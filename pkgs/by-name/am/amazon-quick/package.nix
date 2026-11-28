{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  writeShellScript,
  curl,
  gnused,
  common-updater-scripts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "amazon-quick";
  version = "1.2.4308";

  src = fetchurl {
    url = "https://desktop.downloads.quick.aws.com/darwin/arm64/quick-external-cloud/Amazon%20Quick-${finalAttrs.version}-arm64-mac.zip";
    hash = "sha512-qxc7JLOAEmWpaYxAPUVxto4EedfB/QMxeJ4zyXDTv8Q/DzQ1tZzxsvuU9AGi+p4sfTfU/vCMXNyIx1fkHLrglA==";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = "Amazon Quick.app";

  dontBuild = true;
  # Preserve the upstream code signature
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Amazon Quick.app"
    cp -R . "$out/Applications/Amazon Quick.app"

    runHook postInstall
  '';

  passthru.updateScript = writeShellScript "update-amazon-quick" ''
    set -euo pipefail
    manifest=$(${lib.getExe curl} -fsSL https://desktop.downloads.quick.aws.com/darwin/arm64/quick-external-cloud-mac.yml)
    version=$(${lib.getExe gnused} -n 's/^version: *//p' <<< "$manifest")
    hash=$(${lib.getExe gnused} -n 's/^sha512: *//p' <<< "$manifest")
    ${lib.getExe' common-updater-scripts "update-source-version"} amazon-quick "$version" "sha512-$hash"
  '';

  meta = {
    description = "Desktop app for Amazon Quick, the AWS agentic AI workspace";
    homepage = "https://aws.amazon.com/quick/desktop/";
    downloadPage = "https://docs.aws.amazon.com/quick/latest/userguide/getting-started-desktop.html";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ tembleking ];
    platforms = [ "aarch64-darwin" ];
  };
})
