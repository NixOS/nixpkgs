{stdenv, fetchurl, pkgconfig, alsaLib, spice-protocol, glib,
 libpciaccess, libxcb, libXrandr, libXinerama, libXfixes, dbus, libdrm,
 systemd}:
stdenv.mkDerivation rec {
  name = "spice-vdagent-0.20.0";
  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "0n9k2kna2gd1zi6jv45zsp2jlv439nz5l5jjijirxqaycwi74srf";
  };
  NIX_CFLAGS_COMPILE = [ "-Wno-error=address-of-packed-member" ];
  patchFlags = [ "-uNp1" ];
  # included in the next release.
  patches = [ ./timeout.diff ];
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
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.aboseley ];
    platforms = stdenv.lib.platforms.linux;
  };
}
