{lib, stdenv, fetchurl, pkg-config, alsa-lib, spice-protocol, glib,
 libpciaccess, libxcb, libXrandr, libXinerama, libXfixes, dbus, libdrm,
 systemd}:
stdenv.mkDerivation rec {
  pname = "spice-vdagent";
  version = "0.21.0";
  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/${pname}-${version}.tar.bz2";
    sha256 = "0n8jlc1pv6mkry161y656b1nk9hhhminjq6nymzmmyjl7k95ymzx";
  };

  # FIXME: May no longer be needed with spice-vdagent versions over 0.21.0
  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  postPatch = ''
    substituteInPlace data/spice-vdagent.desktop --replace /usr $out
  '';
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib spice-protocol glib libdrm
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
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.aboseley ];
    platforms = lib.platforms.linux;
  };
}
