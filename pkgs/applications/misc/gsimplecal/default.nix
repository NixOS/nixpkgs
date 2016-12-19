{ stdenv, fetchurl, automake, autoconf, pkgconfig, gtk3 }:

stdenv.mkDerivation rec {
  name = "gsimplecal-${version}";
  version = "2.1";

  src = fetchurl {
    url = "https://github.com/dmedvinsky/gsimplecal/archive/v${version}.tar.gz";
    sha256 = "1sa05ifjp41xipfspk5n6l3wzpzmp3i45q88l01p4l6k6drsq336";
  };

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig automake autoconf gtk3 ];

  preConfigure = "./autogen.sh";

  meta = {
    homepage = http://dmedvinsky.github.io/gsimplecal/;
    description = "Lightweight calendar application written in C++ using GTK";
    longDescription = ''
      gsimplecal was intentionally made for use with tint2 panel in the
      openbox environment to be launched upon clock click, but of course it
      will work without it. In fact, binding the gsimplecal to some hotkey in
      you window manager will probably make you happy. The thing is that when
      it is started it first shows up, when you run it again it closes the
      running instance. In that way it is very easy to integrate anywhere. No
      need to write some wrapper scripts or whatever.

      Also, you can configure it to not only show the calendar, but also
      display multiple clocks for different world time zones.
    '';
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.romildo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
