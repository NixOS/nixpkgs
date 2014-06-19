{ stdenv, fetchurl, qt4 }:
stdenv.mkDerivation rec {
  name = "navipowm-0.2.4";

  src = fetchurl {
    url = mirror://sourceforge/navipowm/NaviPOWM-0.2.4.tar.gz;
    sha256 = "1kdih8kwpgcgfh6l6njkr9gq2j5hv39xvzmzgvhip553kn6bss7b";
  };

  configurePhase = ''
    cd Qt/KDevelop
    qmake
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/${name}/Icons
    cp bin/NaviPOWM $out/bin
    cp ../../common/Config/navipowm.ini $out/share/${name}
    cp ../../common/Images/* $out/share/${name}
  '';

  buildInputs = [ qt4 ];

  meta = {
    homepage = http://navipowm.sourceforge.net/;
    description = "Car navigation system";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
