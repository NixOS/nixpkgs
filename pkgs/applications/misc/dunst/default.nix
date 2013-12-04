{ stdenv, fetchgit, coreutils , unzip, which, pkgconfig , dbus
, freetype, xdg_utils , libXext, glib, pango , cairo, libX11, libnotify
, libxdg_basedir , libXScrnSaver, xproto, libXinerama , perl, gdk_pixbuf
}:

stdenv.mkDerivation rec {
  rev = "6a3a855b48a3db64821d1cf8a91c5ee2815a2b2d";
  name = "dunst-0-${stdenv.lib.strings.substring 0 7 rev}";

  # 1.0.0 release doesn't include 100% CPU fix
  # https://github.com/knopwob/dunst/issues/98
  src = fetchgit {
    inherit rev;
    url = "https://github.com/knopwob/dunst.git";
    sha256 = "0m7yki16d72xm9n2m2fjszd8phqpn5b95q894cz75pmd0sv1j6bj";
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
    export VERSION=${rev};
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
