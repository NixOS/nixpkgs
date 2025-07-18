{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  intltool,
  avahi,
  curl,
  dbus-glib,
  gettext,
  gtk3,
  libmpdclient,
  libsoup_2_4,
  libxml2,
  taglib,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ario";
  version = "1.6";

  src = fetchurl {
    url = "mirror://sourceforge/ario-player/ario-${finalAttrs.version}.tar.gz";
    hash = "sha256-FELt6O75lDhEidctAo1/exocge/nN/cUdYfdAsdy0Jo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gettext
    intltool
    wrapGAppsHook3
  ];

  buildInputs = [
    avahi
    curl
    dbus-glib
    gtk3
    libmpdclient
    libsoup_2_4
    libxml2
    taglib
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for file in $out/lib/ario/plugins/*.dylib; do
      ln -s $file $out/lib/ario/plugins/$(basename $file .dylib).so
    done
  '';

  meta = {
    description = "GTK client for MPD (Music player daemon)";
    mainProgram = "ario";
    homepage = "https://ario-player.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ garrison ];
    platforms = lib.platforms.all;
  };
})
