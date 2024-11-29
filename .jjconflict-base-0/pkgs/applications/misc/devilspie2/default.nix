{ lib, stdenv, fetchurl, intltool, pkg-config, glib, gtk, lua, libwnck }:

stdenv.mkDerivation rec {
  pname = "devilspie2";
  version = "0.44";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/devilspie2/devilspie2-${version}.tar.xz";
    sha256 = "Cp8erdKyKjGBY+QYAGXUlSIboaQ60gIepoZs0RgEJkA=";
  };

  nativeBuildInputs = [ intltool pkg-config ];
  buildInputs = [ glib gtk lua libwnck ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp bin/devilspie2 $out/bin
    cp devilspie2.1 $out/share/man/man1
  '';

  meta = with lib; {
    description = "Window matching utility";
    longDescription = ''
      Devilspie2 is a window matching utility, allowing the user to
      perform scripted actions on windows as they are created. For
      example you can script a terminal program to always be
      positioned at a specific screen position, or position a window
      on a specific workspace.
    '';
    homepage = "https://www.nongnu.org/devilspie2/";
    license = licenses.gpl3;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.linux;
    mainProgram = "devilspie2";
  };
}
