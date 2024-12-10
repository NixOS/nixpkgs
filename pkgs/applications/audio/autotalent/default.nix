{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "autotalent";
  version = "0.2";

  src = fetchzip {
    url = "http://tombaran.info/${pname}-${version}.tar.gz";
    sha256 = "19srnkghsdrxxlv2c7qimvyslxz63r97mkxfq78vbg654l3qz1a6";
  };

  makeFlags = [
    "INSTALL_PLUGINS_DIR=$(out)/lib/ladspa"
  ];

  # To avoid name clashes, plugins should be compiled with symbols hidden, except for `ladspa_descriptor`:
  preConfigure = ''
    sed -r 's/^CFLAGS.*$/\0 -fvisibility=hidden/' -i Makefile

    sed -r 's/^const LADSPA_Descriptor \*/__attribute__ ((visibility ("default"))) \0/' -i autotalent.c
  '';

  meta = with lib; {
    homepage = "http://tombaran.info/autotalent.html";
    description = "A real-time pitch correction LADSPA plugin (no MIDI control)";
    license = licenses.gpl2;
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.linux;
  };
}
