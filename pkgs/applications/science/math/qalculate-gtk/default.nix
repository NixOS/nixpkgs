{ stdenv, fetchurl, intltool, pkgconfig, libqalculate, gtk, gnome2 }:
stdenv.mkDerivation rec {
  name = "qalculate-gtk-${version}";
  version = "0.9.7";

  src = fetchurl {
    url = "mirror://sourceforge/qalculate/${name}.tar.gz";
    sha256 = "0b986x5yny9vrzgxlbyg80b23mxylxv2zz8ppd9svhva6vi8xsm4";
  };

  hardening_format = false;

  nativeBuildInputs = [ intltool pkgconfig ];
  buildInputs = [ libqalculate gtk gnome2.libglade gnome2.libgnome gnome2.scrollkeeper ];

  meta = with stdenv.lib; {
    description = "The ultimate desktop calculator";
    homepage = http://qalculate.sourceforge.net;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
