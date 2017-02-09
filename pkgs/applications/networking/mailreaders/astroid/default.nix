{ stdenv, fetchFromGitHub, scons, pkgconfig, gnome3, gmime, webkitgtk24x
, libsass, notmuch, boost, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "astroid-${version}";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "astroidmail";
    repo = "astroid";
    rev = "v${version}";
    sha256 = "0r3hqwwr68bjhqaa1r3l9brbmvdp11pf8vhsjlvm5zv520z5y1rf";
  };

  patches = [ ./propagate-environment.patch ];

  nativeBuildInputs = [ scons pkgconfig wrapGAppsHook ];

  buildInputs = [ gnome3.gtkmm gmime webkitgtk24x libsass gnome3.libpeas
                  notmuch boost gnome3.gsettings_desktop_schemas
                  gnome3.adwaita-icon-theme ];

  buildPhase = "scons --prefix=$out build";
  installPhase = "scons --prefix=$out install";

  meta = {
    homepage = "https://astroidmail.github.io/";
    description = "GTK+ frontend to the notmuch mail system";
    maintainers = [ stdenv.lib.maintainers.bdimcheff ];
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
