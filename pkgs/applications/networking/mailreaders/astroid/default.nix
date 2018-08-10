{ stdenv, fetchFromGitHub, cmake, pkgconfig, gnome3, gmime3, protobuf
, libsass, notmuch, boost, wrapGAppsHook, glib-networking }:

stdenv.mkDerivation rec {
  name = "astroid-${version}";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "astroidmail";
    repo = "astroid";
    rev = "v${version}";
    sha256 = "105x5g44hng3fi03h67j3an53088148jbq8726nmcp0zs0cy9gac";
  };

  nativeBuildInputs = [ cmake pkgconfig wrapGAppsHook ];

  buildInputs = [
    boost glib-networking gmime3 gnome3.gsettings-desktop-schemas gnome3.gtkmm
    gnome3.libpeas gnome3.webkitgtk libsass notmuch protobuf
  ];

  meta = with stdenv.lib; {
    homepage = https://astroidmail.github.io/;
    description = "GTK+ frontend to the notmuch mail system";
    maintainers = with maintainers; [ bdimcheff SuprDewd ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
