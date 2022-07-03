{ lib, stdenv, fetchurl, qmake4Hook, unzip, qt4 }:

stdenv.mkDerivation rec {
  pname = "qmetro";
  version = "0.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/qmetro/qmetro-${version}.zip";
    sha256 = "1zdj87lzcr43gr2h05g17z31pd22n5kxdwbvx7rx656rmhv0sjq5";
  };

  nativeBuildInputs = [ qmake4Hook unzip ];

  buildInputs = [ qt4 ];

  postPatch = ''
    sed -e 's#Exec=/usr/bin/qmetro#Exec=qmetro#' -i rc/qmetro.desktop
    echo 'LIBS += -lz' >> qmetro.pro
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/qmetro/";
    description = "Worldwide transit maps viewer";
    license = licenses.gpl3;

    maintainers = with maintainers; [ orivej ];
    platforms = platforms.unix;
  };
}
