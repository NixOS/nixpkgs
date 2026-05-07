{
  fetchurl,
  lib,
  stdenv,
  meson,
  ninja,
  gettext,
  pkg-config,
  pulseaudioFull,
  glibmm,
  gtkmm3,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paprefs";
  version = "1.2";

  src = fetchurl {
    url = "https://freedesktop.org/software/pulseaudio/paprefs/paprefs-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-s/IeQNw5NtFeP/yRD7DAfBS4jowodxW0VqlIwXY49jM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    pulseaudioFull
    glibmm
    gtkmm3
  ];

  meta = {
    description = "PulseAudio Preferences";
    mainProgram = "paprefs";

    longDescription = ''
      PulseAudio Preferences (paprefs) is a simple GTK based configuration
      dialog for the PulseAudio sound server.
    '';

    homepage = "http://freedesktop.org/software/pulseaudio/paprefs/";

    license = lib.licenses.gpl2Plus;

    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
