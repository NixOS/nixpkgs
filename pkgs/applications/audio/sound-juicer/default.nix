{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, glib
, gtk3
, itstool
, libxml2
, brasero
, libcanberra-gtk3
, gnome
, gst_all_1
, libmusicbrainz5
, libdiscid
, isocodes
, gsettings-desktop-schemas
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "sound-juicer";
  version = "3.40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "LuiCdEORvrTG1koPaCX7dlUQtwbsK3BL+0LkKvquHeY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    itstool
    libxml2
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    brasero
    libcanberra-gtk3
    gnome.adwaita-icon-theme
    gsettings-desktop-schemas
    libmusicbrainz5
    libdiscid
    isocodes
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "A Gnome CD Ripper";
    homepage = "https://wiki.gnome.org/Apps/SoundJuicer";
    maintainers = [ maintainers.bdimcheff ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
