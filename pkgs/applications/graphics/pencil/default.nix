{ stdenv, fetchurl, xulrunner }:

stdenv.mkDerivation rec {
  name = "pencil-2.0.5";

  src = fetchurl {
    url = "http://evoluspencil.googlecode.com/files/${name}.tar.gz";
    sha256 = "0rn5nb08p8wph5s5gajkil6y06zgrm86p4gnjdgv76czx1fqazm0";
  };

  # Pre-built package
  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out"
    cp -r usr/* "$out"
    cp COPYING "$out/share/pencil"
    sed -e "s|/usr/bin/xulrunner|${xulrunner}/bin/xulrunner|" \
        -e "s|/usr/share/pencil|$out/share/pencil|" \
        -i "$out/bin/pencil"
    sed -e "s|/usr/bin/pencil|$out/bin/pencil|" \
        -e "s|Icon=.*|Icon=$out/share/pencil/skin/classic/icon.svg|" \
        -i "$out/share/applications/pencil.desktop"
  '';

  meta = with stdenv.lib; {
    description = "GUI prototyping/mockup tool";
    homepage = http://pencil.evolus.vn/;
    license = licenses.gpl2; # Commercial license is also available
    maintainers = [ maintainers.bjornfor ];
    platforms = platforms.linux;
  };
}
