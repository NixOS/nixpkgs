{
  autoPatchelfHook,
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openinfraquote";
  version = "1.10.0";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      suffix = selectSystem {
        aarch64-linux = "linux-arm64";
        x86_64-darwin = "darwin-amd64";
        x86_64-linux = "linux-amd64";
      };
      hash = selectSystem {
        aarch64-linux = "sha256-cS9RPUQSmeoMFgclbg7GAMNuwtRiZlXLzo4v3onj1lU=";
        x86_64-darwin = "sha256-O8oZOWLj83WcjUAuNS8WoUgYEkOMdB7uocZD7vMVIhw=";
        x86_64-linux = "sha256-27Ceina/cB4+WMwQbawmSWq5i3CL267IpwQkN0onJw0";
      };
    in
    fetchurl {
      url = "https://github.com/terrateamio/openinfraquote/releases/download/v${finalAttrs.version}/oiq-${suffix}-v${finalAttrs.version}.tar.gz";
      inherit hash;
    };

  nativeBuildInputs = [ autoPatchelfHook ];

  dontBuild = true;
  dontStrip = stdenv.hostPlatform.isDarwin;

  unpackCmd = ''
    tar -xzf $src
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 oiq -t $out/bin
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/oiq --help
    runHook postInstallCheck
  '';

  meta = {
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
      "aarch64-linux"
    ];
    description = "Fast, open-source tool for estimating infrastructure costs from Terraform plans and state files";
    mainProgram = "oiq";
    maintainers = with lib.maintainers; [ mtrsk ];
    license = lib.licenses.mpl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    homepage = "https://openinfraquote.readthedocs.io/en/latest/";
  };
})
