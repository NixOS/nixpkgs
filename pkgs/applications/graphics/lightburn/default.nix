{ lib, stdenv, fetchurl, p7zip
, nss, nspr, libusb1
, qtbase, qtmultimedia, qtserialport, cups
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "lightburn";
  version = "1.4.05";

  nativeBuildInputs = [
    p7zip
    autoPatchelfHook
  ];

  src = fetchurl {
    url = "https://github.com/LightBurnSoftware/deployment/releases/download/${version}/LightBurn-Linux64-v${version}.7z";
    sha256 = "sha256-GLwxzSTzunbFrfT5e1xeHuy3O+kokb4fi4BPsFZ9tOA=";
  };

  buildInputs = [
    nss nspr libusb1
    qtbase qtmultimedia qtserialport cups
  ];

  unpackPhase = ''
    7z x $src
  '';

  installPhase = ''
    mkdir -p $out/share $out/bin
    cp -ar LightBurn $out/share/LightBurn
    ln -s $out/share/LightBurn/AppRun $out/bin/LightBurn
  '';

  dontWrapQtApps = true;

  meta = {
    description = "Layout, editing, and control software for your laser cutter";
    homepage = "https://lightburnsoftware.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ q3k ];
    platforms = [ "x86_64-linux" ];
  };
}
