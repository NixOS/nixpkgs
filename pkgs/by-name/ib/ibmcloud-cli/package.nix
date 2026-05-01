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
  platform =
    if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
      "macos_arm64"
    else if stdenv.hostPlatform.isDarwin then
      "macos"
    else
      "linux_${arch}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ibmcloud-cli";
  version = "2.43.0";

  src = fetchurl {
    url = "https://download.clis.cloud.ibm.com/ibm-cloud-cli/${finalAttrs.version}/binaries/IBM_Cloud_CLI_${finalAttrs.version}_${platform}.tgz";
    hash =
      {
        "x86_64-darwin" = "sha256-oNXb4RNdDC5vqyheTtghjuxRP9qwFFP3Qk8gNziGCsg=";
        "aarch64-darwin" = "sha256-bWxmo+b4+qfqdp/5EYzCyxfBM8q1Hhex/xdjCuwU9LQ=";
        "x86_64-linux" = "sha256-M4Z6e1GjicYEHaXoUWlNdms7VG38gPL4a85atrZMteE=";
        "aarch64-linux" = "sha256-99+HNNxQQlmRxpyLCOipzZmamokGjFrPSfajnpDJ0cY=";
        "i686-linux" = "sha256-nQlO49rJVwSRMiqeN6ed/C1l+9G7Ta1W8isuQWautq8=";
        "powerpc64le-linux" = "sha256-5A4N6ppm7w5cNbFWMrKJ3mSgj8eSJogS+WfY6liBXTE=";
        "s390x-linux" = "sha256-WFPrrZOTxcqmxylo7XXj1FzljiboufCSyxNOOZ2nsk0=";
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
