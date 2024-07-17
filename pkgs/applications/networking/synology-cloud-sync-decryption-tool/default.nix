{
  lib,
  writeScript,
  qt5,
  fetchurl,
  autoPatchelfHook,
}:

qt5.mkDerivation rec {
  pname = "synology-cloud-sync-decryption-tool";
  version = "027";

  src = fetchurl {
    url = "https://global.download.synology.com/download/Utility/SynologyCloudSyncDecryptionTool/${version}/Linux/x86_64/SynologyCloudSyncDecryptionTool-${version}_x64.tar.gz";
    sha256 = "sha256-EWxADvkfhnMwHIauJj3pH6SvSkkrc4cwAhsf1pWOOWQ=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $NIX_BUILD_TOP/SynologyCloudSyncDecryptionTool $out/bin

    runHook postInstall
  '';

  passthru.updateScript = writeScript "update-synology-cloud-sync-decryption-tool" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts

    set -euo pipefail

    version="$(curl -s https://www.synology.com/en-uk/releaseNote/SynologyCloudSyncDecryptionTool \
             | grep -oP '(?<=data-version=")\d+' \
             | head -1)"
    update-source-version synology-cloud-sync-decryption-tool "$version"
  '';

  meta = with lib; {
    description = "A desktop tool to decrypt data encrypted by Cloud Sync.";
    homepage = "https://kb.synology.com/en-global/DSM/help/SynologyCloudSyncDecryptionTool/synologycloudsyncdecryptiontool";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ kalbasit ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "SynologyCloudSyncDecryptionTool";
  };
}
