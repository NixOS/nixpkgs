{
  stdenv,
  lib,
  fetchurl,
  unzip,
  libusb1,
  linuxPackages,
  evdi ? linuxPackages.evdi,
  makeBinaryWrapper,
  patchelf,
}:

let
  sources = lib.importJSON ./sources.json;

  libPath = lib.makeLibraryPath [
    stdenv.cc.cc
    libusb1
    evdi
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "instantview";
  inherit (sources) version;

  src = fetchurl {
    inherit (sources) url hash;
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    unzip
    makeBinaryWrapper
    patchelf
  ];

  buildInputs = [
    libusb1
    evdi
  ];

  unpackPhase = ''
    runHook preUnpack
    unzip "$src"
    chmod +x SMIUSBDisplay-driver.${finalAttrs.version}.run
    ./SMIUSBDisplay-driver.${finalAttrs.version}.run --target . --noexec
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 x64/SMIUSBDisplayManager $out/bin/SMIUSBDisplayManager

    install -d $out/lib/instantview
    install -m644 \
      Bootloader0.bin Bootloader1.bin firmware0.bin \
      USBDisplay.bin USBDisplay770.bin \
      $out/lib/instantview/

    # Binary DT_NEEDED is libevdi.so.1; nixpkgs evdi installs libevdi.so
    ln -s ${lib.getLib evdi}/lib/libevdi.so $out/lib/instantview/libevdi.so.1

    install -Dm755 ${./smi-udev.sh} $out/lib/instantview/smi-udev.sh
    install -d $out/lib/udev/rules.d
    substitute ${./99-instantview.rules} $out/lib/udev/rules.d/99-instantview.rules \
      --subst-var-by smiUdev "$out/lib/instantview/smi-udev.sh"

    patchelf \
      --set-interpreter "$(cat ${stdenv.cc}/nix-support/dynamic-linker)" \
      --set-rpath "$out/lib/instantview:${libPath}" \
      $out/bin/SMIUSBDisplayManager

    wrapProgram $out/bin/SMIUSBDisplayManager \
      --chdir "$out/lib/instantview"

    patchShebangs $out/lib/instantview

    runHook postInstall
  '';

  dontStrip = true;
  dontPatchELF = true;

  passthru = {
    inherit sources;
    updateScript = {
      command = [ ./update.sh ];
      supportedFeatures = [ "commit" ];
    };
  };

  meta = {
    description = "Silicon Motion SM76x InstantView USB display driver for Linux";
    homepage = "https://www.siliconmotion.com/events/instantview/";
    changelog = sources.releaseNotes;
    # EVDI creates DRM devices; Wayland compositors may or may not expose them
    # (test per host). Packaging does not require X11.
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ aspauldingcode ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
    mainProgram = "SMIUSBDisplayManager";
  };
})
