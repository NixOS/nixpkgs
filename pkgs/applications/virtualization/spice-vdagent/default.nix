{stdenv, fetchurl, pkgconfig, alsaLib, spice-protocol, glib,
 libpciaccess, libxcb, libXrandr, libXinerama, libXfixes, dbus,
 systemd}:
stdenv.mkDerivation rec {
  name = "spice-vdagent-0.18.0";
  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "1bmyvapwj1x0m6y8q0r1df2q37vsnb04qkgnnrfbnzf1qzipxvl0";
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
    homepage = https://www.spice-space.org/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.aboseley ];
    platforms = stdenv.lib.platforms.linux;
  };
}
