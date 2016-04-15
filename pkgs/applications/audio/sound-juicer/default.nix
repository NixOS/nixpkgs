{ stdenv, fetchurl, pkgconfig, gtk3, intltool, itstool, libxml2, brasero
, libcanberra_gtk3, gnome3, gst_all_1, libmusicbrainz5, libdiscid, isocodes
, wrapGAppsHook }:

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

  buildInputs = [ pkgconfig gtk3 intltool itstool libxml2 brasero libcanberra_gtk3
                  gnome3.gsettings_desktop_schemas libmusicbrainz5 libdiscid isocodes
                  gnome3.dconf wrapGAppsHook
                  makeWrapper gnome3.dconf
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad
                  gst_all_1.gst-libav
                ];

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
