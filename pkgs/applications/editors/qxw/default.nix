{ lib, stdenv, fetchurl, pkg-config, gtk2, pcre }:

stdenv.mkDerivation rec {
  pname = "qxw";
  version = "20200708";

  src = fetchurl {
    url = "https://www.quinapalus.com/qxw-${version}.tar.gz";
    sha256 = "1si3ila7137c7x4mp3jv1q1mh3jp0p4khir1yz1rwy0mp3znwv7d";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 pcre ];

  makeFlags = [ "DESTDIR=$(out)" ];

  patchPhase = ''
    sed -i 's/ `dpkg-buildflags[^`]*`//g;
            /mkdir -p/d;
            s/cp -a/install -D/;
            s,/usr/games,/bin,' Makefile
  '';

  meta = with lib; {
    description = "A program to help create and publish crosswords";
    homepage = "https://www.quinapalus.com/qxw.html";
    license = licenses.gpl2;
    maintainers = [ maintainers.tckmn ];
    platforms = platforms.linux;
    mainProgram = "qxw";
  };
}
