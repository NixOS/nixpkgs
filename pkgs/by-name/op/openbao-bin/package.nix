{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "openbao-bin";
  version = "2.0.0";

  src =
    let
      inherit (stdenv.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "Linux_x86_64";
        aarch64-linux = "Linux_arm64";
        x86_64-darwin = "Darwin_x86_64";
        aarch64-darwin = "Darwin_arm64";
      };
      sha256 = selectSystem {
        x86_64-linux = "sha256-mg+yBfh6W2xlWDNgHZExO6SvywioJ7/qJU2gLP865mU=";
        aarch64-linux = "sha256-ugR+slO6bZ1r3btPzzO2q31dqHMYNgyGOFMPH578xLc=";
        x86_64-darwin = "sha256-GCWXRe0clMu139BKIV9LhnylxNmGXAMx1aVfmxaZhDs=";
        aarch64-darwin = "sha256-9/Xi6fRsOL1WB6uu0X0Yph1chYoKIOUtyRfECX359pY=";
      };
    in
    fetchzip {
      url = "https://github.com/openbao/openbao/releases/download/v${version}/bao_${version}_${suffix}.tar.gz";
      stripRoot = false;
      inherit sha256;
    };

  dontConfigure = true;
  dontBuild = true;
  dontStrip = stdenv.isDarwin;

  installPhase = ''
    runHook preInstall
    install -D bao $out/bin/bao
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/bao --help
    $out/bin/bao version
    runHook postInstallCheck
  '';

  dontPatchELF = true;
  dontPatchShebangs = true;

  passthru.updateScript = ./update-bin.sh;

  meta = with lib; {
    homepage = "https://www.openbao.org/";
    description = "Open source, community-driven fork of Vault managed by the Linux Foundation";
    changelog = "https://github.com/openbao/openbao/blob/v${version}/CHANGELOG.md";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mpl20;
    mainProgram = "bao";
    maintainers = with maintainers; [ joseph-flinn ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
  };
}
