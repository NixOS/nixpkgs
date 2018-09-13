{ stdenv, fetchurl, pkgconfig, glib, gtk3, intltool, itstool, libxml2, brasero
, libcanberra-gtk3, gnome3, gst_all_1, libmusicbrainz5, libdiscid, isocodes
, wrapGAppsHook }:

let
  pname = "sound-juicer";
  version = "3.16.1";
in stdenv.mkDerivation rec{
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0mx6n901vb97hsv0cwaafjffj75s1kcp8jsqay90dy3099849dyz";
  };

  nativeBuildInputs = [ pkgconfig intltool itstool libxml2 wrapGAppsHook ];
  buildInputs = [
    glib gtk3 brasero libcanberra-gtk3 gnome3.defaultIconTheme
    gnome3.gsettings-desktop-schemas libmusicbrainz5 libdiscid isocodes
    gst_all_1.gstreamer gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
  ];

  NIX_CFLAGS_COMPILE="-Wno-error=format-nonliteral";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "A Gnome CD Ripper";
    homepage = https://wiki.gnome.org/Apps/SoundJuicer;
    maintainers = [ maintainers.bdimcheff ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
