{ stdenv, fetchFromGitHub, scons, pkgconfig, gnome3, gmime, webkitgtk24x
, libsass, notmuch, boost, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "astroid-${version}";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "astroidmail";
    repo = "astroid";
    rev = "v${version}";
    sha256 = "1gjrdls1mz8y8bca7s8l965l0m7s2sb6g7a90gy848admjsyav7h";
  };

  nativeBuildInputs = [ scons pkgconfig wrapGAppsHook ];

  buildInputs = [ gnome3.gtkmm gmime webkitgtk24x libsass gnome3.libpeas
                  notmuch boost gnome3.gsettings_desktop_schemas
                  gnome3.adwaita-icon-theme ];

  buildPhase = "scons --propagate-environment --prefix=$out build";
  installPhase = "scons --propagate-environment --prefix=$out install";

  meta = {
    homepage = "https://astroidmail.github.io/";
    description = "GTK+ frontend to the notmuch mail system";
    maintainers = [ stdenv.lib.maintainers.bdimcheff ];
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
