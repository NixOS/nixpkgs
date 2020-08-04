{ stdenv, fetchurl
, gnome3
, gnunet
, gnutls
, gtk3
, libextractor
, libgcrypt
, libxml2
, pkg-config
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnunet-gtk";
  inherit (gnunet) version;

  src = fetchurl {
    url = "mirror://gnu/gnunet/${pname}-${version}.tar.gz";
    sha256 = "1zdzgq16h77w6ybwg3lqjsjr965np6iqvncqvkbj07glqd4wss0j";
  };

  nativeBuildInputs= [
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gnome3.glade
    gnunet
    gnutls
    gtk3
    libextractor
    libgcrypt
    libxml2
  ];

  patchPhase = "patchShebangs pixmaps/icon-theme-installer";

  meta = gnunet.meta // {
    description = "GNUnet GTK User Interface";
    homepage = "https://git.gnunet.org/gnunet-gtk.git";
  };
}
