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
    ensureDir $out/bin
    cp bin/NaviPOWM $out/bin
  '';

  buildInputs = [ qt4 ];

  meta = {
    homepage = http://navipowm.sourceforge.net/;
    description = "Car navigation system";
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
