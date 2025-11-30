{
  fetchurl,
  lib,
  stdenv,
  libconfuse,
  yajl,
  alsa-lib,
  libpulseaudio,
  libnl,
  meson,
  ninja,
  perl,
  pkg-config,
  asciidoc,
  xmlto,
  docbook_xml_dtd_45,
  docbook_xsl,
}:

stdenv.mkDerivation rec {
  pname = "i3status";
  version = "2.15";

  src = fetchurl {
    url = "https://i3wm.org/i3status/i3status-${version}.tar.xz";
    sha256 = "sha256-bGf1LK5PE533ZK0cxzZWK+D5d1B5G8IStT80wG6vIgU=";
  };

  separateDebugInfo = true;
  nativeBuildInputs = [
    meson
    ninja
    perl
    pkg-config
    asciidoc
    xmlto
    docbook_xml_dtd_45
    docbook_xsl
  ];
  buildInputs = [
    libconfuse
    yajl
    alsa-lib
    libpulseaudio
    libnl
  ];

  meta = {
    description = "Generates a status line for i3bar, dzen2, xmobar or lemonbar";
    homepage = "https://i3wm.org";
    maintainers = with lib.maintainers; [ stapelberg ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    mainProgram = "i3status";
  };

}
