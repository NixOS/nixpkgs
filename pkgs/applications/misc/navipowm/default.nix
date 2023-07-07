{ lib, stdenv, fetchurl, qt4, qmake4Hook }:
stdenv.mkDerivation rec {
  pname = "navipowm";
  version = "0.2.4";

  src = fetchurl {
    url = "mirror://sourceforge/navipowm/NaviPOWM-${version}.tar.gz";
    sha256 = "1kdih8kwpgcgfh6l6njkr9gq2j5hv39xvzmzgvhip553kn6bss7b";
  };

  preConfigure = ''
    cd Qt/KDevelop
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/navipowm-${version}/Icons
    cp bin/NaviPOWM $out/bin
    cp ../../common/Config/navipowm.ini $out/share/navipowm-${version}
    cp ../../common/Images/* $out/share/navipowm-${version}
  '';

  buildInputs = [ qt4 ];
  nativeBuildInputs = [ qmake4Hook ];

  meta = {
    homepage = "https://navipowm.sourceforge.net/";
    description = "Car navigation system";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux;
  };
}
