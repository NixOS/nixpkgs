{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  name = "aic8800-firmware";
  version = "4.0+git20250410.b99ca8b6-2";

  src = fetchFromGitHub {
    owner = "radxa-pkg";
    repo = "aic8800";
    tag = finalAttrs.version;
    hash = "sha256-ol3FwwzUS3x8YQp8xYZJHqQO8nPmZmJN/TjmqcA9G6g=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware/aic8800_fw/PCIE/
    mkdir -p $out/lib/firmware/aic8800_fw/SDIO/
    mkdir -p $out/lib/firmware/aic8800_fw/USB/

    cp -rv src/PCIE/driver_fw/fw/* $out/lib/firmware/aic8800_fw/PCIE/
    cp -rv src/SDIO/driver_fw/fw/* $out/lib/firmware/aic8800_fw/SDIO/
    cp -rv src/USB/driver_fw/fw/* $out/lib/firmware/aic8800_fw/USB/

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/radxa-pkg/aic8800";
    description = "Aicsemi aic8800 Wi-Fi driver firmware";
    # https://github.com/radxa-pkg/aic8800/issues/54
    license = with lib.licenses; [
      gpl2Only
    ];
    maintainers = with lib.maintainers; [ Cryolitia ];
    platforms = lib.platforms.linux;
  };
})
