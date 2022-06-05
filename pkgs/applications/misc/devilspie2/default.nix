{ lib, stdenv, fetchurl, intltool, pkg-config, glib, gtk, lua, libwnck }:

stdenv.mkDerivation rec {
  pname = "devilspie2";
  version = "0.43";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/devilspie2/devilspie2_${version}-src.tar.gz";
    sha256 = "0a7qjl2qd4099kkkbwa1y2fk48s21jlr409lf9mij7mlc9yc3zzc";
  };

  nativeBuildInputs = [ intltool pkg-config ];
  buildInputs = [ glib gtk lua libwnck ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp bin/devilspie2 $out/bin
    cp devilspie2.1 $out/share/man/man1
  '';

  meta = with lib; {
    description = "A window matching utility";
    longDescription = ''
      Devilspie2 is a window matching utility, allowing the user to
      perform scripted actions on windows as they are created. For
      example you can script a terminal program to always be
      positioned at a specific screen position, or position a window
      on a specific workspace.
    '';
    homepage = "https://www.gusnan.se/devilspie2/";
    license = licenses.gpl3;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.linux;
  };
}
