{ stdenv, fetchurl
, glade
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
  version = "0.13.1";

  src = fetchurl {
    url = "mirror://gnu/gnunet/${pname}-${version}.tar.gz";
    sha256 = "1zdzgq16h77w6ybwg3lqjsjr965np6iqvncqvkbj07glqd4wss0j";
  };

  nativeBuildInputs= [
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    glade
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
    # configure: error: compiling gnunet-gtk requires GNUnet core headers
    broken = true;
  };
}
