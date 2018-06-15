{stdenv, fetchurl, pkgconfig, alsaLib, spice-protocol, glib,
 libpciaccess, libxcb, libXrandr, libXinerama, libXfixes, dbus,
 systemd}:
stdenv.mkDerivation rec {
  name = "spice-vdagent-0.17.0";
  src = fetchurl {
    url = "http://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "0gdkyylyg1hksg0i0anvznqfli2q39335fnrmcd6847frpc8njpi";
  };
  postPatch = ''
    substituteInPlace data/spice-vdagent.desktop --replace /usr $out
  '';
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ alsaLib spice-protocol glib
                  libpciaccess libxcb libXrandr libXinerama libXfixes
                  dbus systemd ] ;
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
