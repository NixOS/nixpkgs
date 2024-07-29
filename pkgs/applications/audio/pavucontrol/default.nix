{
  fetchurl,
  lib,
  stdenv,
  pkg-config,
  intltool,
  libpulseaudio,
  gtkmm4,
  libsigcxx,
  # Since version 6.0, libcanberra is optional
  withLibcanberra ? true,
  libcanberra-gtk3,
  json-glib,
  adwaita-icon-theme,
  wrapGAppsHook4,
  meson,
  ninja,
  libpressureaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pavucontrol";
  version = "6.0";

  src = fetchurl {
    url = "https://freedesktop.org/software/pulseaudio/${finalAttrs.pname}/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-hchg1o/x+CzZjHKpJXGEvuOSmVeKsSLSm8Uey+z79ls=";
  };

  buildInputs = [
    libpulseaudio
    gtkmm4
    libsigcxx
    (lib.optionals withLibcanberra libcanberra-gtk3)
    json-glib
    adwaita-icon-theme
    libpressureaudio
  ];

  nativeBuildInputs = [
    pkg-config
    intltool
    wrapGAppsHook4
    meson
    ninja
  ];

  mesonFlags = [
    "--prefix=${placeholder "out"}"
    (lib.mesonBool "lynx" false)
  ];

  enableParallelBuilding = true;

  meta = {
    changelog = "https://freedesktop.org/software/pulseaudio/pavucontrol/#news";
    description = "PulseAudio Volume Control";
    homepage = "http://freedesktop.org/software/pulseaudio/pavucontrol/";
    license = lib.licenses.gpl2Plus;
    longDescription = ''
      PulseAudio Volume Control (pavucontrol) provides a GTK
      graphical user interface to connect to a PulseAudio server and
      easily control the volume of all clients, sinks, etc.
    '';
    mainProgram = "pavucontrol";
    maintainers = with lib.maintainers; [ abbradar ];
    platforms = lib.platforms.linux;
  };
})
