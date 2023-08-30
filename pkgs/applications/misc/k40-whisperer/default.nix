{ stdenv
, makeBinaryWrapper
, writeText
, python3
, fetchzip
, graphicsmagick
, inkscape
, lib
, copyDesktopItems
, makeDesktopItem
, udevGroup ? "k40"
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [
    lxml
    pyusb
    pillow
    pyclipper
    tkinter
  ]);

  udevRule = writeText "k40-whisperer.rules" ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="5512", ENV{DEVTYPE}=="usb_device", MODE="0664", GROUP="${udevGroup}"
  '';
in stdenv.mkDerivation (finalAttrs: {
  pname = "k40-whisperer";
  version = "0.62";

  src = fetchzip {
    url = "https://www.scorchworks.com/K40whisperer/K40_Whisperer-${finalAttrs.version}_src.zip";
    stripRoot = true;
    hash = "sha256-3O+lCpmsCCu61REuxhrV8Uy01AgEGq/1DlMhjo45URM=";
  };

  dontBuild = true;

  nativeBuildInputs = [
    copyDesktopItems
    graphicsmagick
    makeBinaryWrapper
  ];

  patchPhase = ''
    runHook prePatch

    substituteInPlace svg_reader.py \
      --replace '"/usr/bin/inkscape"' '"${inkscape}/bin/inkscape"'

    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -p * $out

    mkdir -p $out/bin
    mkdir -p $out/lib/udev/rules.d
    mkdir -p $out/share/icons/hicolor/128x128/apps

    ln -s ${udevRule} $out/lib/udev/rules.d/97-k40-whisperer.rules

    gm convert "$out/scorchworks.ico" "$out/share/icons/hicolor/128x128/apps/k40-whisperer.png"

    makeWrapper '${pythonEnv.interpreter}' $out/bin/k40-whisperer \
      --add-flags $out/k40_whisperer.py \
      --prefix PYTHONPATH : $out

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "k40-whisperer";
      desktopName = "K40 Whisperer";
      genericName = "Laser cutter control software";
      exec = "k40-whisperer %F";
      icon = "k40-whisperer";
      categories = [ "Utility" ];
      keywords = [ "k40 whisperer" "k40" "laser" ];
    })
  ];

  meta = {
    description = "Control software for the stock K40 Laser controller";
    downloadPage = "https://www.scorchworks.com/K40whisperer/k40whisperer.html#download";
    homepage = "https://www.scorchworks.com/K40whisperer/k40whisperer.html";
    license = lib.licenses.gpl3;
    longDescription = ''
      K40 Whisperer is an alternative to the the Laser Draw (LaserDRW) program that comes with the cheap Chinese laser cutters available on E-Bay and Amazon.
      K40 Whisperer reads SVG and DXF files, interprets the data and sends commands to the K40 controller to move the laser head and control the laser accordingly.
      K40 Whisperer does not require a USB key (dongle) to function.
    '';
    mainProgram = "k40-whisperer";
    maintainers = with lib.maintainers; [ fooker ];
    platforms = lib.platforms.all;
  };
})
