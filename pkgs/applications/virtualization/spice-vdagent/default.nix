{stdenv, fetchurl, pkgconfig, alsaLib, spice_protocol, glib,
 libpciaccess, libxcb, libXrandr, libXinerama, libXfixes}:
stdenv.mkDerivation rec {
  name = "spice-vdagent-0.16.0";
  src = fetchurl {
    url = "http://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "0z8gwc5va2i64mjippavmxajdb9az83ffqyhlbynm6dxw131d5av";
  };
  postPatch = ''
    substituteInPlace data/spice-vdagent.desktop --replace /usr $out
  '';
  buildInputs = [ pkgconfig alsaLib spice_protocol glib
                  libpciaccess libxcb libXrandr libXinerama libXfixes ] ;
  meta = {
    description = "Enhanced SPICE integration for linux QEMU guest";
    longDescription = ''
       Spice agent for linux guests offering
       * Client mouse mode
       * Copy and paste
       * Automatic adjustment of the X-session resolution
         to the client resolution
       * Multiple displays
    '';
    homepage = http://www.spice-space.org/home.html;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.aboseley ];
    platforms = stdenv.lib.platforms.linux;
  };
}
