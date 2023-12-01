{ fetchurl
, lib
, stdenv
, pkg-config
, intltool
, libpulseaudio
, gtkmm3
, libsigcxx
, libcanberra-gtk3
, json-glib
, gnome
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "pavucontrol";
  version = "5.0";

  src = fetchurl {
    url = "https://freedesktop.org/software/pulseaudio/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-zityw7XxpwrQ3xndgXUPlFW9IIcNHTo20gU2ry6PTno=";
  };

  buildInputs = [
    libpulseaudio
    gtkmm3
    libsigcxx
    libcanberra-gtk3
    json-glib
    gnome.adwaita-icon-theme
  ];

  nativeBuildInputs = [ pkg-config intltool wrapGAppsHook ];

  configureFlags = [ "--disable-lynx" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "PulseAudio Volume Control";

    longDescription = ''
      PulseAudio Volume Control (pavucontrol) provides a GTK
      graphical user interface to connect to a PulseAudio server and
      easily control the volume of all clients, sinks, etc.
    '';

    homepage = "http://freedesktop.org/software/pulseaudio/pavucontrol/";

    license = lib.licenses.gpl2Plus;

    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
    mainProgram = "pavucontrol";
  };
}
