{
  lib,
  stdenv,
  fetchurl,
  glib,
  gtk3,
  libffcall,
  pkg-config,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtk-server";
  version = "2.4.6";

  src = fetchurl {
    url = "https://www.gtk-server.org/stable/gtk-server-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-sFL3y068oXDKgkEUcNnGVsNSPBdI1NzpsqdYJfmOQoA=";
  };

  preConfigure = ''
    cd src
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    libffcall
    glib
    gtk3
  ];

  configureOptions = [ "--with-gtk3" ];

  meta = {
    homepage = "http://www.gtk-server.org/";
    description = "Gtk-server for interpreted GUI programming";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
