{ stdenv, fetchFromGitHub, makeWrapper
, pkgconfig, which, perl, libXrandr
, cairo, dbus, systemd, gdk_pixbuf, glib, libX11, libXScrnSaver
, libXinerama, libnotify, pango, xorgproto, librsvg, dunstify ? false
}:

stdenv.mkDerivation rec {
  name = "dunst-${version}";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "dunst-project";
    repo = "dunst";
    rev = "v${version}";
    sha256 = "1rwbylygd88r61yrxc7ckg9svgq8b1i2falr0mk9sabqxzn9050s";
  };

  nativeBuildInputs = [ perl pkgconfig which systemd makeWrapper ];

  buildInputs = [
    cairo dbus gdk_pixbuf glib libX11 libXScrnSaver
    libXinerama libnotify pango xorgproto librsvg libXrandr
  ];

  outputs = [ "out" "man" ];

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=$(version)"
    "SERVICEDIR_DBUS=$(out)/share/dbus-1/services"
    "SERVICEDIR_SYSTEMD=$(out)/lib/systemd/user"
  ];

  buildFlags = if dunstify then [ "dunstify" ] else [];

  postInstall = stdenv.lib.optionalString dunstify ''
    install -Dm755 dunstify $out/bin
  '' + ''
    wrapProgram $out/bin/dunst \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  meta = with stdenv.lib; {
    description = "Lightweight and customizable notification daemon";
    homepage = https://dunst-project.org/;
    license = licenses.bsd3;
    # NOTE: 'unix' or even 'all' COULD work too, I'm not sure
    platforms = platforms.linux;
    maintainers = [ maintainers.domenkozar ];
  };
}
