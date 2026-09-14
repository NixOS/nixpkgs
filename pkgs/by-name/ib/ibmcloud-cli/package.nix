{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:
let
  stdenv = stdenvNoCC;
  arch =
    with stdenv.hostPlatform;
    if isx86_64 then
      "amd64"
    else if isAarch64 then
      "arm64"
    else if isi686 then
      "386"
    else if isPower64 && isLittleEndian then
      "ppc64le"
    else if isS390x then
      "s390x"
    else
      throw "Unsupported arch: ${stdenv.hostPlatform.system}";
  platform = if stdenv.hostPlatform.isDarwin then "macos_arm64" else "linux_${arch}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ibmcloud-cli";
  version = "2.47.0";

  src = fetchurl {
    url = "https://download.clis.cloud.ibm.com/ibm-cloud-cli/${finalAttrs.version}/binaries/IBM_Cloud_CLI_${finalAttrs.version}_${platform}.tgz";
    hash =
      {
        "aarch64-darwin" = "sha256-UQj9SnHk7p8Ia/FMaVeMytbiog0N0rajw7362xsqne4=";
        "x86_64-linux" = "sha256-Va9XCWG4hltCYYKL5d0yS+Au+Di6NO1th6VVXZ6t6Zw=";
        "aarch64-linux" = "sha256-GWu3hxjKxjwHexvB6BczbfOHvAT1FUdsTw34DRmIvWE=";
        "i686-linux" = "sha256-SMwaQ663mpkD6VuaBhYtFP0egmNx9sbeZ7DbzMx0gnY=";
        "powerpc64le-linux" = "sha256-clITx0+/eLpV+vkODk8kLcgj0sS7rQO0vTOA8y/dYk4=";
        "s390x-linux" = "sha256-S3wbT/xjPwLUPEelxRtkOusZFOFY5Co332m6QmCEbXs=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ibmcloud $out/bin/ibmcloud
    mkdir -p $out/share/ibmcloud
    cp LICENSE NOTICE $out/share/ibmcloud
    installShellCompletion --cmd ibmcloud --bash <($out/bin/ibmcloud --generate-bash-completion)

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Command line client for IBM Cloud";
    homepage = "https://cloud.ibm.com/docs/cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "i686-linux"
      "powerpc64le-linux"
      "s390x-linux"
    ]
    ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "ibmcloud";
  };
})
