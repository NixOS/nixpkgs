{
  fetchurl,
  lib,
  stdenv,
  pkg-config,
  intltool,
  libpulseaudio,
  gtkmm3,
  libsigcxx,
  libcanberra-gtk3,
  json-glib,
  adwaita-icon-theme,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pavucontrol";
  version = "5.0";

  src = fetchurl {
    url = "https://freedesktop.org/software/pulseaudio/${finalAttrs.pname}/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-zityw7XxpwrQ3xndgXUPlFW9IIcNHTo20gU2ry6PTno=";
  };

  buildInputs = [
    libpulseaudio
    gtkmm3
    libsigcxx
    libcanberra-gtk3
    json-glib
    adwaita-icon-theme
  ];

  nativeBuildInputs = [
    pkg-config
    intltool
    wrapGAppsHook3
  ];

  configureFlags = [ "--disable-lynx" ];

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
