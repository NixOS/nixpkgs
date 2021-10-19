{ lib
, stdenv
, fetchFromGitLab
, autoreconfHook
, intltool
, pkg-config
, wrapGAppsHook
, gnome
, gtkmm3
, json-glib
, libcanberra-gtk3
, libpulseaudio
, libsigcxx
}:

stdenv.mkDerivation rec {
  pname = "pavucontrol";
  version = "5.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pulseaudio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0HfwqU58OsWOdbNKENQoFiW3nf9LEJog/wGiqMUvYCU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gnome.adwaita-icon-theme
    gtkmm3
    json-glib
    libcanberra-gtk3
    libpulseaudio
    libsigcxx
  ];

  meta = with lib; {
    description = "PulseAudio Volume Control";
    longDescription = ''
      PulseAudio Volume Control (pavucontrol) provides a GTK
      graphical user interface to connect to a PulseAudio server and
      easily control the volume of all clients, sinks, etc.
    '';
    homepage = "http://freedesktop.org/software/pulseaudio/pavucontrol/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbradar globin ];
    platforms = platforms.linux;
  };
}
