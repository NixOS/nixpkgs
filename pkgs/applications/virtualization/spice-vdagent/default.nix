{stdenv, fetchurl, pkgconfig, alsaLib, spice-protocol, glib,
 libpciaccess, libxcb, libXrandr, libXinerama, libXfixes, dbus, libdrm,
 systemd}:
stdenv.mkDerivation rec {
  pname = "spice-vdagent";
  version = "0.21.0";
  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/${pname}-${version}.tar.bz2";
    sha256 = "0n8jlc1pv6mkry161y656b1nk9hhhminjq6nymzmmyjl7k95ymzx";
  };
  postPatch = ''
    substituteInPlace data/spice-vdagent.desktop --replace /usr $out
  '';
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ alsaLib spice-protocol glib libdrm
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
    homepage = "https://www.spice-space.org/";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.aboseley ];
    platforms = stdenv.lib.platforms.linux;
  };
}
