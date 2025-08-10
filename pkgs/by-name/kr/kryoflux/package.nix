{
  stdenv,
  lib,
  autoPatchelfHook,
  fetchurl,
  makeWrapper,
  jre,
  fmt_9,
  libusb1,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "kryoflux";
  version = "3.50";
  src = fetchurl {
    url = "https://www.kryoflux.com/download/kryoflux_${finalAttrs.version}_linux_r2.tar.gz";
    hash = "sha256-qGFXu0FkmCB7cffOqNiOluDUww19MA/UuEVElgmSd3o=";
  };
  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [
    fmt_9
    libusb1
  ];
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/java
    cp -r {docs,testimages,schematics} $out/share
    cp dtc/kryoflux-ui.jar $out/share/java
    makeWrapper ${jre}/bin/java $out/bin/kryoflux-ui \
      --add-flags "-jar $out/share/java/kryoflux-ui.jar" \
      --set PATH "$out/bin"
    tar -C $out -xf dtc/${stdenv.hostPlatform.linuxArch}/kryoflux-dtc*.tar.gz \
      --strip-components=1 \
      --wildcards '*/bin/*' '*/lib/*' '*/share/*'

    mkdir -p $out/etc/udev/rules.d
    echo 'ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="03eb", ATTR{idProduct}=="6124", GROUP="floppy", MODE="0660"' > 80-kryoflux.rules

    runHook postInstall
  '';
  meta = {
    description = "Software UI to accompany KryoFlux, the renowned forensic floppy controller";
    homepage = "https://kryoflux.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "kryoflux-ui";
    platforms = with lib.platforms; lib.intersectLists linux (x86_64 ++ aarch64);
  };
})
