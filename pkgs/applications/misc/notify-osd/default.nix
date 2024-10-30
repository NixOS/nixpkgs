{ lib, stdenv, fetchurl, pkg-config, glib, libwnck, libnotify, dbus-glib, makeWrapper, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  pname = "notify-osd";
  version = "0.9.34";

  src = fetchurl {
    url = "https://launchpad.net/notify-osd/precise/${version}/+download/notify-osd-${version}.tar.gz";
    sha256 = "0g5a7a680b05x27apz0y1ldl5csxpp152wqi42s107jymbp0s20j";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [
    glib libwnck libnotify dbus-glib
    gsettings-desktop-schemas
  ];

  configureFlags = [ "--libexecdir=$(out)/bin" ];

  preFixup = ''
    wrapProgram "$out/bin/notify-osd" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with lib; {
    description = "Daemon that displays passive pop-up notifications";
    mainProgram = "notify-osd";
    homepage = "https://launchpad.net/notify-osd";
    license = licenses.gpl3;
    maintainers = [ maintainers.bodil ];
    platforms = platforms.linux;
  };
}
