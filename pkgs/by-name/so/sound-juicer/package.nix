{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk3,
  itstool,
  libxml2,
  brasero,
  libcanberra-gtk3,
  gnome,
  adwaita-icon-theme,
  gst_all_1,
  libmusicbrainz,
  libdiscid,
  isocodes,
  gsettings-desktop-schemas,
  wrapGAppsHook3,
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
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    brasero
    libcanberra-gtk3
    adwaita-icon-theme
    gsettings-desktop-schemas
    libmusicbrainz
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
    description = "Gnome CD Ripper";
    mainProgram = "sound-juicer";
    homepage = "https://gitlab.gnome.org/GNOME/sound-juicer";
    maintainers = [ maintainers.bdimcheff ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
