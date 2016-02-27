{ stdenv, fetchurl, intltool, pkgconfig, glib, gtk, lua, libwnck3 }:

stdenv.mkDerivation rec {
  name = "devilspie2-${version}";
  version = "0.39";

  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/devilspie2/devilspie2_0.39-src.tar.gz";
    sha256 = "07b74ffc078e5f01525d9da7a1978b4c1a9725b814b344f83a1a203cf4caae09";
  };

  buildInputs = [ intltool pkgconfig glib gtk lua libwnck3 ];

  patchPhase = ''
    sed -i -e s@/usr/local@$out@ Makefile
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp bin/devilspie2 $out/bin
    cp devilspie2.1 $out/share/man/man1
  '';

  meta = with stdenv.lib; {
    description = "Devilspie2 is a window matching utility";
    longDescription = ''
      Devilspie2 is a window matching utility, allowing the user to
      perform scripted actions on windows as they are created. For
      example you can script a terminal program to always be
      positioned at a specific screen position, or position a window
      on a specific workspace.
    '';
    homepage = http://www.gusnan.se/devilspie2/;
    license = licenses.gpl3;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.linux;
  };
}
