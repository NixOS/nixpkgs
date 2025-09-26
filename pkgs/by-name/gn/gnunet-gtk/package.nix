{
  stdenv,
  fetchurl,
  glade,
  gnunet,
  gnutls,
  gtk3,
  libextractor,
  libgcrypt,
  libsodium,
  libxml2,
  pkg-config,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnunet-gtk";
  version = "0.24.0";

  src = fetchurl {
    url = "mirror://gnu/gnunet/gnunet-gtk-${finalAttrs.version}.tar.gz";
    hash = "sha256-rsQzMvOoQEuushd0jBGQt9j6zXj2G1SMax8d4QoDV6s=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
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
})
