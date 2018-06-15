{ stdenv, fetchFromGitHub, cmake, pkgconfig, gnome3, gmime3, webkitgtk24x-gtk3
, libsass, notmuch, boost, wrapGAppsHook, glib-networking }:

stdenv.mkDerivation rec {
  name = "astroid-${version}";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "astroidmail";
    repo = "astroid";
    rev = "v${version}";
    sha256 = "1z48rvlzwi7bq7j55rnb0gg1a4k486yj910z2cxz1p46lxk332j1";
  };

  nativeBuildInputs = [ cmake pkgconfig wrapGAppsHook ];

  buildInputs = [ gnome3.gtkmm gmime3 webkitgtk24x-gtk3 libsass gnome3.libpeas
                  notmuch boost gnome3.gsettings-desktop-schemas
                  glib-networking ];

  meta = with stdenv.lib; {
    homepage = https://astroidmail.github.io/;
    description = "GTK+ frontend to the notmuch mail system";
    maintainers = with maintainers; [ bdimcheff SuprDewd ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
