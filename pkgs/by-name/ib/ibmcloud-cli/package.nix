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
  version = "2.40.0";

  src = fetchurl {
    url = "https://download.clis.cloud.ibm.com/ibm-cloud-cli/${finalAttrs.version}/binaries/IBM_Cloud_CLI_${finalAttrs.version}_${platform}.tgz";
    hash =
      {
        "x86_64-darwin" = "sha256-/sekaJxa8+inOBsHucyPE3yWM+Z+64jArGwCht8Corc=";
        "aarch64-darwin" = "sha256-JrTFbufKjX9uUwUcfxCDjqbZx6drgSmqn0F/xtce/mE=";
        "x86_64-linux" = "sha256-Zu6XFQeD9Dlny6cex7X6P428MiQftwn9RR4QL3H/0AU=";
        "aarch64-linux" = "sha256-pfHhAszhbbLKkJnwP94dCaDZNFTLr+2tnO3aHxOch+U=";
        "i686-linux" = "sha256-v8azVYFa6bBAPJZoOnLr3W+spQZlPFmR92wNTvtRS34=";
        "powerpc64le-linux" = "sha256-L3cBkNV0iMNhk6b/v1i3JcQJ1SxbffOrs5xqMEOTMY8=";
        "s390x-linux" = "sha256-UIBu8konMu8Y2U4mix8H9T6Y/2plVVnoiJJgKhGgGs4=";
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
