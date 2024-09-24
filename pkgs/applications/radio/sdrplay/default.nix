{ stdenv, lib, fetchurl, autoPatchelfHook, writeText, udev, libusb1 }:
let
  arch =
    if stdenv.isx86_64 then "amd64"
    else if stdenv.isi686 then "amd64"
    else if stdenv.isAarch64 then "arm64"
    else if stdenv.isAarch32 then "armhf"
    else throw "unsupported architecture";

  version = "3.15.2";

  udev_rules = writeText "66-sdrplay.rules" ''
    SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1df7",ATTRS{idProduct}=="2500",MODE:="0666"
    SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1df7",ATTRS{idProduct}=="3000",MODE:="0666"
    SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1df7",ATTRS{idProduct}=="3010",MODE:="0666"
    SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1df7",ATTRS{idProduct}=="3020",MODE:="0666"
    SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1df7",ATTRS{idProduct}=="3030",MODE:="0666"
    SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1df7",ATTRS{idProduct}=="3050",MODE:="0666"
    SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1df7",ATTRS{idProduct}=="3060",MODE:="0666"
  '';
in
stdenv.mkDerivation rec {
  pname = "sdrplay";
  inherit version;

  src = fetchurl {
    url = "https://www.sdrplay.com/software/SDRplay_RSP_API-Linux-${version}.run";
    sha256 = "sha256-OpfKdkJju+dvsPIiDmQIlCNX6IZMGeFAim1ph684L+M=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ libusb1 udev stdenv.cc.cc.lib ];

  unpackPhase = ''
    sh "$src" --noexec --target source
  '';

  sourceRoot = "source";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/{bin,lib,include,lib/udev/rules.d}
    majorVersion="${lib.concatStringsSep "." (lib.take 1 (builtins.splitVersion version))}"
    majorMinorVersion="${lib.concatStringsSep "." (lib.take 2 (builtins.splitVersion version))}"
    libName="libsdrplay_api"
    cp "${arch}/$libName.so.$majorMinorVersion" $out/lib/
    ln -s "$out/lib/$libName.so.$majorMinorVersion" "$out/lib/$libName.so.$majorVersion"
    ln -s "$out/lib/$libName.so.$majorVersion" "$out/lib/$libName.so"
    cp "${arch}/sdrplay_apiService" $out/bin/
    cp -r inc/* $out/include/
    cp -r $udev_rules $out/lib/udev/rules.d/
  '';

  meta = with lib; {
    description = "SDRplay API";
    longDescription = ''
      Proprietary library and api service for working with SDRplay devices. For documentation and licensing details see
      https://www.sdrplay.com/docs/SDRplay_API_Specification_v${lib.concatStringsSep "." (lib.take 2 (builtins.splitVersion version))}.pdf
    '';
    homepage = "https://www.sdrplay.com/downloads/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ pmenke zaninime ];
    platforms = platforms.linux;
    mainProgram = "sdrplay_apiService";
  };
}
