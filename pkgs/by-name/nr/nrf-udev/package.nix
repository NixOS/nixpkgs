{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nrf-udev";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = "nrf-udev";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bEIAsz9ZwX6RTzhv5/waFZ5a3KlnwX4kQs29+475zN0=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r nrf-udev_*/lib $out

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "Udev rules for nRF (Nordic Semiconductor) development kits";
    homepage = "https://github.com/NordicSemiconductor/nrf-udev";
    changelog = "https://github.com/NordicSemiconductor/nrf-udev/releases/tag/${finalAttrs.src.rev}";
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = with maintainers; [ h7x4 ];
  };
})
