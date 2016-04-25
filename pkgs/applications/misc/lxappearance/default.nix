{ stdenv, fetchurl, intltool, pkgconfig, libX11, gtk }:

stdenv.mkDerivation rec {
  name = "lxappearance-0.6.2";

  src = fetchurl{
    url = "mirror://sourceforge/project/lxde/LXAppearance/${name}.tar.xz";
    sha256 = "07r0xbi6504zjnbpan7zrn7gi4j0kbsqqfpj8v2x94gr05p16qj4";
  };

  nativeBuildInputs = [ intltool pkgconfig ];
  buildInputs = [ libX11 gtk ];

  meta = {
    description = "A lightweight program for configuring the theme and fonts of gtk applications";
    maintainers = [ stdenv.lib.maintainers.hinton ];
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl2;
    homepage = "http://lxappearance.sourceforce.net/";
  };
}
