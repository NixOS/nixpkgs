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

stdenv.mkDerivation rec {
  pname = "ario";
  version = "1.6";

  src = fetchurl {
    url = "mirror://sourceforge/ario-player/${pname}-${version}.tar.gz";
    sha256 = "16nhfb3h5pc7flagfdz7xy0iq6kvgy6h4bfpi523i57rxvlfshhl";
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

  meta = with lib; {
    description = "GTK client for MPD (Music player daemon)";
    mainProgram = "ario";
    homepage = "https://ario-player.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.garrison ];
    platforms = platforms.all;
  };
}
