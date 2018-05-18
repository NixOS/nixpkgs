{ stdenv, pkgconfig, glib }:

stdenv.mkDerivation {
  name = "chrootenv";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib ];

  buildCommand = ''
    cc ${./chrootenv.c} $(pkg-config --cflags --libs glib-2.0) -o $out
  '';

  meta = with stdenv.lib; {
    description = "Setup mount/user namespace for FHS emulation";
    license = licenses.free;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.linux;
  };
}
