{ stdenv, fetchurl
, gnome3
, gnunet
, gnutls
, gtk3
, libextractor
, libgcrypt
, libqrencode
, libunique3
, libxml2
, pkg-config
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnunet-gtk";
  version = "0.14.0";

  src = fetchurl {
    url = "mirror://gnu/gnunet/${pname}-${version}.tar.gz";
    sha256 = "sha256-ipMSf2GxpEwkhcTJx94xOZ7bI7nCXZptaSf4QlY9LKM=";
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
    libqrencode
    libunique3
    libxml2
  ];

  patchPhase = "patchShebangs pixmaps/icon-theme-installer";
  GNUNET_CFLAGS="${gnunet}/include";
  configureFlags = "--with-gnutls=${gnutls}";

  meta = gnunet.meta // {
    description = "GNUnet GTK User Interface";
    homepage = "https://git.gnunet.org/gnunet-gtk.git";
  };
}
