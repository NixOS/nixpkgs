{ lib, stdenv, patchelf, fetchurl, p7zip
, nss, nspr, libusb1
, qtbase, qtmultimedia, qtserialport
, autoPatchelfHook, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "lightburn";
  version = "1.1.03";

  nativeBuildInputs = [
    p7zip
    autoPatchelfHook
    wrapQtAppsHook
  ];

  src = fetchurl {
    url = "https://github.com/LightBurnSoftware/deployment/releases/download/${version}/LightBurn-Linux64-v${version}.7z";
    sha256 = "sha256-X7hAkzVqIABpyFokiYaMGZqSda69cKhKghFDWDEVOow=";
  };

  buildInputs = [
    nss nspr libusb1
    qtbase qtmultimedia qtserialport
  ];

  # We nuke the vendored Qt5 libraries that LightBurn ships and instead use our
  # own.
  unpackPhase = ''
    7z x $src
    rm -rf LightBurn/lib LightBurn/plugins
  '';

  installPhase = ''
    mkdir -p $out/share $out/bin
    cp -ar LightBurn $out/share/LightBurn
    ln -s $out/share/LightBurn/LightBurn $out/bin

    wrapQtApp $out/bin/LightBurn
  '';

  meta = {
    description = "Layout, editing, and control software for your laser cutter";
    homepage = "https://lightburnsoftware.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ q3k ];
    platforms = [ "x86_64-linux" ];
  };
}
