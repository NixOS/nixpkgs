{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  versionCheckHook,
}:
let
  os = if stdenv.hostPlatform.isDarwin then "macos" else "linux";
  arch = if stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "clouddrive2";
  version = "1.0.13";

  src = fetchurl {
    url = "https://github.com/cloud-fs/cloud-fs.github.io/releases/download/v${finalAttrs.version}/clouddrive-2-${os}-${arch}-${finalAttrs.version}.tgz";
    hash =
      {
        x86_64-linux = "sha256-5WFJyFZnAm3k9D8Sf/rbCFKUTqYZyCpsNi9Rp+8UoxQ=";
        aarch64-linux = "sha256-DEkWHezR54hQESTWZqHEHZaSlnT5ItlXa05sCiIVlac=";
        aarch64-darwin = "sha256-EwWm3CG9eLCM1/D4FaJYe3Ter9zebYLjkktB2nt/wSI=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/opt/clouddrive2
    cp -r wwwroot "$out/opt/clouddrive2/wwwroot"
    cp -r clouddrive "$out/opt/clouddrive2/clouddrive"
    makeWrapper $out/opt/clouddrive2/clouddrive $out/bin/clouddrive

    runHook postInstall
  '';

  nativeInstallCheckPhaseInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.clouddrive2.com";
    changelog = "https://github.com/cloud-fs/cloud-fs.github.io/releases/tag/v${finalAttrs.version}";
    description = "Multi-cloud drives management tool supporting mounting cloud drives locally";
    longDescription = ''
      CloudDrive is a powerful multi-cloud drive management tool that provides a multi-cloud
      drive solution that includes local mounting of cloud drives. It supports lots of cloud
      drives in China.
    '';
    mainProgram = "clouddrive";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ltrump ];
  };
})
