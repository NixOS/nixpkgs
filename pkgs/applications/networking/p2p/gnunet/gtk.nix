{ stdenv, fetchgit, pkgconfig
, autoreconfHook, wrapGAppsHook
, libgcrypt, libextractor, libxml2
, gnome3, gnunet, gnutls, gtk3 }:

stdenv.mkDerivation rec {
  pname = "gnunet-gtk";
  version = "0.12.0";

  src = fetchgit {
    url = "https://git.gnunet.org/gnunet-gtk.git";
    rev = "v${version}";
    sha256 = "1ccasng1b4bj0kqhbfhiv0j1gnc4v2ka5f7wxvka3iwp90g7rax6";
  };

  nativeBuildInputs= [ autoreconfHook wrapGAppsHook pkgconfig ];
  buildInputs = [ libgcrypt libextractor libxml2 gnunet gnome3.glade gnutls gtk3 ];

  patchPhase = "patchShebangs pixmaps/icon-theme-installer";

  meta = with stdenv.lib; {
    description = "GNUnet GTK User Interface";
    homepage = "https://git.gnunet.org/gnunet-gtk.git";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pstn ];
    platforms = platforms.gnu ++ platforms.linux;
  };
}
