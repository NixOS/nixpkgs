{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  audiofile,
  autoconf,
  automake,
  gettext,
  gnome2,
  gtk2,
  libGL,
  libjack2,
  libpulseaudio,
  libtool,
  libxml2,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "industrializer";
  version = "0.2.7";

  src = fetchurl {
    url = "mirror://sourceforge/project/industrializer/psindustrializer-${finalAttrs.version}.tar.xz";
    hash = "sha256-28w23zAex41yUzeh9l+kPgGrTk2XHb9CGVXdy8VEyEw=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
    gettext # autopoint
    libxml2 # AM_PATH_XML2
    alsa-lib # AM_PATH_ALSA
    libtool
  ];

  buildInputs = [
    alsa-lib
    audiofile
    gnome2.gtkglext
    gtk2
    libGL
    libjack2
    libxml2
    libpulseaudio
  ];

  strictDeps = true;

  preConfigure = "./autogen.sh";

  # jack.c:190:5: error: initialization of 'const gchar * (*)(int)' {aka 'const char * (*)(int)'} from incompatible pointer type 'const char * (*)(int * (*)())
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  meta = {
    description = "This program generates synthesized percussion sounds using physical modelling";
    longDescription = ''
      The range of sounds possible include but is not limited to cymbal sounds, metallic noises, bubbly sounds, and chimes.
      After a sound is rendered, it can be played and then saved to a .WAV file.
    '';
    homepage = "https://sourceforge.net/projects/industrializer/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    mainProgram = "psindustrializer";
  };
})
