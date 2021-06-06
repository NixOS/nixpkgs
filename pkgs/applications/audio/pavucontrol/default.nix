{ fetchurl, fetchpatch, lib, stdenv, pkg-config, intltool, libpulseaudio,
gtkmm3 , libcanberra-gtk3, gnome, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "pavucontrol";
  version = "4.0";

  src = fetchurl {
    url = "https://freedesktop.org/software/pulseaudio/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1qhlkl3g8d7h72xjskii3g1l7la2cavwp69909pzmbi2jyn5pi4g";
  };

  patches = [
    # Can be removed with the next version bump
    # https://gitlab.freedesktop.org/pulseaudio/pavucontrol/-/merge_requests/20
    (fetchpatch {
      name = "streamwidget-fix-drop-down-wayland.patch";
      url = "https://gitlab.freedesktop.org/pulseaudio/pavucontrol/-/commit/ae278b8643cf1089f66df18713c8154208d9a505.patch";
      sha256 = "066vhxjz6gmi2sp2n4pa1cdsxjnq6yml5js094g5n7ld34p84dpj";
  })];

  buildInputs = [ libpulseaudio gtkmm3 libcanberra-gtk3
                  gnome.adwaita-icon-theme ];

  nativeBuildInputs = [ pkg-config intltool wrapGAppsHook ];

  configureFlags = [ "--disable-lynx" ];

  meta = with lib; {
    description = "PulseAudio Volume Control";

    longDescription = ''
      PulseAudio Volume Control (pavucontrol) provides a GTK
      graphical user interface to connect to a PulseAudio server and
      easily control the volume of all clients, sinks, etc.
    '';

    homepage = "http://freedesktop.org/software/pulseaudio/pavucontrol/";

    license = lib.licenses.gpl2Plus;

    maintainers = with maintainers; [ abbradar globin ];
    platforms = platforms.linux;
  };
}
