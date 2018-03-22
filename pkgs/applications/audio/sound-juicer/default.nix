{ stdenv, fetchurl, pkgconfig, gtk3, intltool, itstool, libxml2, brasero
, libcanberra-gtk3, gnome3, gst_all_1, libmusicbrainz5, libdiscid, isocodes
, makeWrapper }:

let
  major = "3.16";
  minor = "1";

in stdenv.mkDerivation rec {
  version = "${major}.${minor}";
  name = "sound-juicer-${version}";

  src = fetchurl {
    url = "http://download.gnome.org/sources/sound-juicer/${major}/${name}.tar.xz";
    sha256 = "0mx6n901vb97hsv0cwaafjffj75s1kcp8jsqay90dy3099849dyz";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 intltool itstool libxml2 brasero libcanberra-gtk3
                  gnome3.gsettings-desktop-schemas libmusicbrainz5 libdiscid isocodes
                  makeWrapper (stdenv.lib.getLib gnome3.dconf)
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad
                  gst_all_1.gst-libav
                ];

  preFixup = ''
    for f in $out/bin/* $out/libexec/*; do
      wrapProgram "$f" \
        --prefix XDG_DATA_DIRS : "${gnome3.gnome-themes-standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
        --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib gnome3.dconf}/lib/gio/modules"
    done
  '';

  postInstall = ''
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = with stdenv.lib; {
    description = "A Gnome CD Ripper";
    homepage = https://wiki.gnome.org/Apps/SoundJuicer;
    maintainers = [ maintainers.bdimcheff ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
