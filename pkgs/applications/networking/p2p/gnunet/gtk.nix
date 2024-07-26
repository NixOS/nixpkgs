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
  version = "0.20.0";

  src = fetchurl {
    url = "mirror://gnu/gnunet/${pname}-${version}.tar.gz";
    sha256 = "sha256-6ZHlDIKrTmr/aRz4k5FtRVxZ7B9Hlh2w42QT4YRsVi0=";
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

  postPatch = "patchShebangs pixmaps/icon-theme-installer";

  postInstall = ''
    ln -s $out/share/gnunet-gtk/gnunet_logo.png $out/share/gnunet/gnunet-logo-color.png
  '';

  meta = gnunet.meta // {
    description = "GNUnet GTK User Interface";
    homepage = "https://git.gnunet.org/gnunet-gtk.git";
  };
}
