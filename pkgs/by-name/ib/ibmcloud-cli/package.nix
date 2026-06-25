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
  version = "2.44.0";

  src = fetchurl {
    url = "https://download.clis.cloud.ibm.com/ibm-cloud-cli/${finalAttrs.version}/binaries/IBM_Cloud_CLI_${finalAttrs.version}_${platform}.tgz";
    hash =
      {
        "x86_64-darwin" = "sha256-V/spVW8FeCXiIjybR9kWb4kbFf60ogo0IoSCo+ewcHU=";
        "aarch64-darwin" = "sha256-TJ9cHwkRtuegPcqkkgGp6ooVAzGWogs+yBq4xjzjVlw=";
        "x86_64-linux" = "sha256-azsOxlWSIpJMDGsbeMy3vXuVs17EERKGvvQoZccOIQU=";
        "aarch64-linux" = "sha256-jWva/7Wou2Y8rzexU/THeRaEYjUt11WYBaNK/qU1uxM=";
        "i686-linux" = "sha256-/RZGCv6nQa4SDG6jsL91wV90bVJYDbRb4b8wVJXCz14=";
        "powerpc64le-linux" = "sha256-ZlZzjxJTQkPtKC4PVyzVGGg9WusMkHhZDhGLPk+MfL0=";
        "s390x-linux" = "sha256-dpj3B2XUi3rR+7i0p8Y7ymAuTxoc/0fClVk3bTjM4Ic=";
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
