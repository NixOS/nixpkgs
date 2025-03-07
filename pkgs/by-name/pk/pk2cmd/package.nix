{
  lib,
  stdenv,
  fetchurl,
  libusb-compat-0_1,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "pk2cmd";
  version = "1.20";
  src = fetchurl {
    url = "https://ww1.microchip.com/downloads/en/DeviceDoc/pk2cmdv${version}LinuxMacSource.tar.gz";
    sha256 = "1yjpi2qshnqfpan4w3ggakkr3znfrx5cxkny92ka7v9na3g2fc4h";
  };

  makeFlags = [
    "LIBUSB=${libusb-compat-0_1.dev}"
    "linux"
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/pk2
    cp pk2cmd $out/bin
    cp PK2DeviceFile.dat $out/share/pk2
    wrapProgram $out/bin/pk2cmd --prefix PATH : $out/share/pk2
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libusb-compat-0_1 ];

  meta = {
    homepage = "https://www.microchip.com/pickit2";
    license = lib.licenses.unfree; # MicroChip-PK2
    description = "Microchip PIC programming software for the PICKit2 programmer";
    mainProgram = "pk2cmd";
  };
}
