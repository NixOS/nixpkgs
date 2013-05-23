{ stdenv, fetchurl, coreutils , unzip, which, pkgconfig , dbus
, freetype, xdg_utils , libXext, glib, pango , cairo, libX11, libnotify
, libxdg_basedir , libXScrnSaver, xproto, libXinerama , perl, gdk_pixbuf
}:

stdenv.mkDerivation rec {
  version = "1.0.0";
  name = "dunst-${version}";

  src = fetchurl {
    url = "https://github.com/knopwob/dunst/archive/v${version}.zip";
    sha256 = "1x6k6jrf219v8hmhqhnnfjycldvsnp7ag8a2y8adp5rhfmgyn671";
  };

  patchPhase = ''
    substituteInPlace "settings.c" \
      --replace "xdgConfigOpen(\"dunst/dunstrc\", \"r\", &xdg" "fopen(\"$out/share/dunst/dunstrc\", \"r\""
  '';

  buildInputs =
  [ coreutils unzip which pkgconfig dbus freetype libnotify gdk_pixbuf
    xdg_utils libXext glib pango cairo libX11 libxdg_basedir
    libXScrnSaver xproto libXinerama perl];

  buildPhase = ''
    export VERSION=${version};
    export PREFIX=$out;
    make dunst;
  '';

  meta = {
    description = "lightweight and customizable notification daemon";
    homepage = http://www.knopwob.org/dunst/;
    license = stdenv.lib.licenses.bsd3;
    # NOTE: 'unix' or even 'all' COULD work too, I'm not sure
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.iElectric ];
  };
}
