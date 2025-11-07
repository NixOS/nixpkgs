{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "stm32flash";
  version = "0.7";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-xMnNi+x52mOxEdFXE+9cws2UfeykEdNdbjBl4ifcQUo=";
  };

  buildFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    # Manually copy, make install copies to /usr/local/bin
    mkdir -pv $out/bin/
    cp stm32flash $out/bin/
  '';

  meta = with lib; {
    description = "Open source flash program for the STM32 ARM processors using the ST bootloader";
    mainProgram = "stm32flash";
    homepage = "https://sourceforge.net/projects/stm32flash/";
    license = lib.licenses.gpl2;
    platforms = platforms.all; # Should work on all platforms
    maintainers = with maintainers; [ elitak ];
  };
}
