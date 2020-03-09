{ lib, stdenv, fetchurl, electron, makeDesktopItem, makeWrapper, nodePackages, autoPatchelfHook}:

stdenv.mkDerivation rec {
  pname = "teleprompter";
  version = "2.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/teleprompter-imaginary-films/imaginary-${pname}-${version}-64bit.tar.gz";
    sha256 = "084ml2l3qg46bsazaapyxdx4zavvxp0j4ycsdpdwk3f94g9xb120";
  };

  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = [ autoPatchelfHook makeWrapper nodePackages.asar ];
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
     type = "Application";
     desktopName = "Teleprompter";
  };

  meta = with lib; {
    description = "The most complete, free, teleprompter app on the web";
    license = [ licenses.gpl3 ];
    homepage = "https://github.com/ImaginarySense/Teleprompter-Core";
    platforms = platforms.linux;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}

