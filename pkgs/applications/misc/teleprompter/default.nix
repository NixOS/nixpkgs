{ lib, stdenv, fetchurl, electron_10, makeDesktopItem, makeWrapper, asar, autoPatchelfHook}:

let
  electron = electron_10;
in
stdenv.mkDerivation rec {
  pname = "teleprompter";
  version = "2.4.0";

  src = fetchurl {
    url = "https://github.com/ImaginarySense/Imaginary-Teleprompter-Electron/releases/download/${lib.versions.majorMinor version}/imaginary-teleprompter-${version}.tar.gz";
    sha256 = "bgdtK8l5d26avv1WUw9cfOgZrIL1q/a9890Ams4yidQ=";
  };

  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = [ autoPatchelfHook makeWrapper asar ];
  installPhase = ''
    mkdir -p $out/bin $out/opt/teleprompter $out/share/applications
    asar e resources/app.asar $out/opt/teleprompter/resources/app.asar.unpacked
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/teleprompter \
      --add-flags "$out/opt/teleprompter/resources/app.asar.unpacked --without-update"
  '';

  desktopItem = makeDesktopItem {
     name = "teleprompter";
     exec = "teleprompter";
     desktopName = "Teleprompter";
  };

  meta = with lib; {
    description = "The most complete, free, teleprompter app on the web";
    license = [ licenses.gpl3Plus ];
    homepage = "https://github.com/ImaginarySense/Teleprompter-Core";
    platforms = platforms.linux;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}

