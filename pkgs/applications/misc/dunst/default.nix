{ stdenv, lib, fetchFromGitHub, makeWrapper
, pkgconfig, which, perl, libXrandr
, cairo, dbus, systemd, gdk-pixbuf, glib, libX11, libXScrnSaver
, libXinerama, libnotify, pango, xorgproto, librsvg, dunstify ? false
}:

stdenv.mkDerivation rec {
  pname = "dunst";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "dunst-project";
    repo = "dunst";
    rev = "v${version}";
    sha256 = "0irwkqcgwkqaylcpvqgh25gn2ysbdm2kydipxfzcq1ddj9ns6f9c";
  };

  nativeBuildInputs = [ perl pkgconfig which systemd makeWrapper ];

  buildInputs = [
    cairo dbus gdk-pixbuf glib libX11 libXScrnSaver
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

  postInstall = lib.optionalString dunstify ''
    install -Dm755 dunstify $out/bin
  '' + ''
    wrapProgram $out/bin/dunst \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  meta = with lib; {
    description = "Lightweight and customizable notification daemon";
    homepage = "https://dunst-project.org/";
    license = licenses.bsd3;
    # NOTE: 'unix' or even 'all' COULD work too, I'm not sure
    platforms = platforms.linux;
    maintainers = with maintainers; [ domenkozar ];
  };
}
