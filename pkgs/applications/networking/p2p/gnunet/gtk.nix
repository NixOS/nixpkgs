{ stdenv, fetchurl
, glade
, gnunet
, gnutls
, gtk3
, libextractor
, libgcrypt
, libsodium
, libxml2
, pkg-config
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnunet-gtk";
  version = "0.15.0";

  src = fetchurl {
    url = "mirror://gnu/gnunet/${pname}-${version}.tar.gz";
    sha256 = "sha256-FLLlqpQ7Bf+oNRUvx7IniVxFusy/tPYxEP2T6VGF7h8=";
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
    libsodium
    libxml2
  ];

  configureFlags = [ "--with-gnunet=${gnunet}" ];

  patchPhase = "patchShebangs pixmaps/icon-theme-installer";

  meta = gnunet.meta // {
    description = "GNUnet GTK User Interface";
    homepage = "https://git.gnunet.org/gnunet-gtk.git";
  };
}
