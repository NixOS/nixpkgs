{ stdenv, fetchFromGitHub
, pkgconfig, which, perl, libXrandr
, cairo, dbus, systemd, gdk_pixbuf, glib, libX11, libXScrnSaver
, libXinerama, libnotify, libxdg_basedir, pango, xproto, librsvg
}:

stdenv.mkDerivation rec {
  name = "dunst-${version}";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "dunst-project";
    repo = "dunst";
    rev = "v${version}";
    sha256 = "1kqlshaflp306yrjjmc28pghi1y5p24vdx4bxf8i4n9khdawb514";
  };

  nativeBuildInputs = [ perl pkgconfig which systemd ];

  buildInputs = [
    cairo dbus gdk_pixbuf glib libX11 libXScrnSaver
    libXinerama libnotify libxdg_basedir pango xproto librsvg libXrandr
  ];

  outputs = [ "out" "man" ];

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=$(version)"
    "SERVICEDIR_DBUS=$(out)/share/dbus-1/services"
    "SERVICEDIR_SYSTEMD=$(out)/lib/systemd/user"
  ];

  meta = with stdenv.lib; {
    description = "Lightweight and customizable notification daemon";
    homepage = https://dunst-project.org/;
    license = licenses.bsd3;
    # NOTE: 'unix' or even 'all' COULD work too, I'm not sure
    platforms = platforms.linux;
    maintainers = [ maintainers.domenkozar ];
  };
}
