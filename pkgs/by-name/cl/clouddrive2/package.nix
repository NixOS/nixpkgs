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
  version = "0.9.5";

  src = fetchurl {
    url = "https://github.com/cloud-fs/cloud-fs.github.io/releases/download/v${finalAttrs.version}/clouddrive-2-${os}-${arch}-${finalAttrs.version}.tgz";
    hash =
      {
        x86_64-linux = "sha256-Gsq5rvr0SeGxCRwAeeFRZBPOe32EIa7uO6SAIuinezA=";
        aarch64-linux = "sha256-M+lCUzoiy/sImBZrOjjeP4eqG3F4wbkMQg9Ho3ELGFo=";
        x86_64-darwin = "sha256-Uyz1wuHICSq5C+n3ZjPinZznhajd6QR36CZgQBm+QRE=";
        aarch64-darwin = "sha256-ZQxRHTzLUAhnL1rRLR9l8Ix5XzxeTAds7XAmEgZ9Xmo=";
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
  versionCheckProgramArg = "--version";
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
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ltrump ];
  };
})
