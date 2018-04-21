{ stdenv, fetchFromGitHub, scons, pkgconfig, gnome3, gmime3, webkitgtk24x-gtk3
, libsass, notmuch, boost, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "astroid-${version}";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "astroidmail";
    repo = "astroid";
    rev = "v${version}";
    sha256 = "0y1i40xbjjvnylqpdkvj0m9fl6f5k9zk1z4pqg3vhj8x1ys8am1c";
  };

  nativeBuildInputs = [ scons pkgconfig wrapGAppsHook ];

  buildInputs = [ gnome3.gtkmm gmime3 webkitgtk24x-gtk3 libsass gnome3.libpeas
                  notmuch boost gnome3.gsettings-desktop-schemas ];

  buildPhase = "scons --propagate-environment --prefix=$out build";
  installPhase = "scons --propagate-environment --prefix=$out install";

  meta = with stdenv.lib; {
    homepage = https://astroidmail.github.io/;
    description = "GTK+ frontend to the notmuch mail system";
    maintainers = with maintainers; [ bdimcheff SuprDewd ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
