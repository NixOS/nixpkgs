{stdenv, fetchurl, pkgconfig, alsaLib, spice-protocol, glib,
 libpciaccess, libxcb, libXrandr, libXinerama, libXfixes, dbus, libdrm,
 systemd}:
stdenv.mkDerivation rec {
  name = "spice-vdagent-0.19.0";
  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "0r9gjx1vcgb4f7g85b1ib045kqa3dqjk12m7342i5y443ihpr9v3";
  };
  NIX_CFLAGS_COMPILE = [ "-Wno-error=address-of-packed-member" ];
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
    homepage = https://www.spice-space.org/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.aboseley ];
    platforms = stdenv.lib.platforms.linux;
  };
}
