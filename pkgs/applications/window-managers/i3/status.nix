{ fetchurl, lib, stdenv, libconfuse, yajl, alsa-lib, libpulseaudio, libnl, meson, ninja, perl, pkg-config, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl }:

stdenv.mkDerivation rec {
  pname = "i3status";
  version = "2.14";

  src = fetchurl {
    url = "https://i3wm.org/i3status/i3status-${version}.tar.xz";
    sha256 = "0929chhvyq9hg4scpcz8r9zn3s9jvbg6a86k3wqa77qg85rh4kaw";
  };

  nativeBuildInputs = [ meson ninja perl pkg-config asciidoc xmlto docbook_xml_dtd_45 docbook_xsl ];
  buildInputs = [ libconfuse yajl alsa-lib libpulseaudio libnl ];

  meta = {
    description = "Generates a status line for i3bar, dzen2, xmobar or lemonbar";
    homepage = "https://i3wm.org";
    maintainers = [ ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    mainProgram = "i3status";
  };

}
