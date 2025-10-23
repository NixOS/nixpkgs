{
  stdenv,
  makeWrapper,
  writeText,
  python3,
  fetchzip,
  inkscape,
  lib,
  udevCheckHook,
  udevGroup ? "k40",
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      lxml
      pyusb
      pillow
      pyclipper
      tkinter
    ]
  );

  udevRule = writeText "k40-whisperer.rules" ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="5512", ENV{DEVTYPE}=="usb_device", MODE="0664", GROUP="${udevGroup}"
  '';

in
stdenv.mkDerivation rec {
  pname = "k40-whisperer";
  version = "0.68";

  src = fetchzip {
    url = "https://www.scorchworks.com/K40whisperer/K40_Whisperer-${version}_src.zip";
    stripRoot = true;
    sha256 = "sha256-Pc6iqBQUoI0dsrf+2dA1ZbxX+4Eks/lVgMGC4SR+oFI=";
  };

  nativeBuildInputs = [
    makeWrapper
    udevCheckHook
  ];

  patchPhase = ''
    substituteInPlace svg_reader.py \
      --replace '"/usr/bin/inkscape"' '"${inkscape}/bin/inkscape"'
  '';

  buildPhase = "";

  doInstallCheck = true;

  installPhase = ''
    mkdir -p $out
    cp -p * $out

    mkdir -p $out/bin
    mkdir -p $out/lib/udev/rules.d

    ln -s ${udevRule} $out/lib/udev/rules.d/97-k40-whisperer.rules

    makeWrapper '${pythonEnv.interpreter}' $out/bin/k40-whisperer \
      --add-flags $out/k40_whisperer.py \
      --prefix PYTHONPATH : $out
  '';

  meta = with lib; {
    description = ''
      Control software for the stock K40 Laser controller
    '';
    mainProgram = "k40-whisperer";
    longDescription = ''
      K40 Whisperer is an alternative to the the Laser Draw (LaserDRW) program that comes with the cheap Chinese laser cutters available on E-Bay and Amazon.
      K40 Whisperer reads SVG and DXF files, interprets the data and sends commands to the K40 controller to move the laser head and control the laser accordingly.
      K40 Whisperer does not require a USB key (dongle) to function.
    '';
    homepage = "https://www.scorchworks.com/K40whisperer/k40whisperer.html";
    downloadPage = "https://www.scorchworks.com/K40whisperer/k40whisperer.html#download";
    license = licenses.gpl3;
    maintainers = with maintainers; [ fooker ];
    platforms = platforms.all;
  };
}
