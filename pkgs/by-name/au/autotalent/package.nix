{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "autotalent";
  version = "0.2";

  src = fetchzip {
    url = "http://tombaran.info/autotalent-${finalAttrs.version}.tar.gz";
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

  meta = {
    homepage = "http://tombaran.info/autotalent.html";
    description = "Real-time pitch correction LADSPA plugin (no MIDI control)";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.michalrus ];
    platforms = lib.platforms.linux;
  };
})
