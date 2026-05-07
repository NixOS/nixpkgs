{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  audiofile,
  autoconf,
  automake,
  autoreconfHook,
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
    autoreconfHook
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

  postPatch = ''
    # Replace obsolete AM_PATH_XML2 with PKG_CHECK_MODULES
    substituteInPlace configure.ac \
      --replace-fail 'AM_PATH_XML2(2.6.0, [], AC_MSG_ERROR(Fatal error: Need libxml2 >= 2.6.0))' \
                     'PKG_CHECK_MODULES([XML], [libxml-2.0 >= 2.6.0])' \
      --replace-fail 'XML_CPPFLAGS' 'XML_CFLAGS'
  '';

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
