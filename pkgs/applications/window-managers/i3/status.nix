{ fetchurl, lib, stdenv, libconfuse, yajl, alsa-lib, libpulseaudio, libnl, pkg-config, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl }:

stdenv.mkDerivation rec {
  pname = "i3status";
  version = "2.13";

  src = fetchurl {
    url = "https://i3wm.org/i3status/i3status-${version}.tar.bz2";
    sha256 = "0rhlzb96mw64z2jnhwz9nibc7pxg549626lz5642xxk5hpzwk2ff";
  };

  nativeBuildInputs = [ pkg-config asciidoc xmlto docbook_xml_dtd_45 docbook_xsl ];
  buildInputs = [ libconfuse yajl alsa-lib libpulseaudio libnl ];

  makeFlags = [ "all" "PREFIX=$(out)" ];

  # This hack is needed because for unknown reasons configure generates a broken makefile on the 2.13 release under nixos
  preBuild = ''
    sed -i -e 's/\$(TEST_LOGS) \$(TEST_LOGS/\$(TEST_LOGS)/g' Makefile
  '';

  meta = {
    description = "Generates a status line for i3bar, dzen2, xmobar or lemonbar";
    homepage = "https://i3wm.org";
    maintainers = [ ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };

}
