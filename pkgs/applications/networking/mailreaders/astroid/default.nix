{ stdenv, fetchFromGitHub, scons, pkgconfig, gnome3, gmime, webkitgtk24x-gtk3
, libsass, notmuch, boost, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "astroid-${version}";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "astroidmail";
    repo = "astroid";
    rev = "v${version}";
    sha256 = "0ha2jd3fvc54amh0x8f58s9ac4r8xgyhvkwd4jvs0h4mfh6cg496";
  };

  nativeBuildInputs = [ scons pkgconfig wrapGAppsHook ];

  buildInputs = [ gnome3.gtkmm gmime webkitgtk24x-gtk3 libsass gnome3.libpeas
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
