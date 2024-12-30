{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  libwnck,
  libnotify,
  dbus-glib,
  makeWrapper,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "notify-osd";
  version = "0.9.34";

  src = fetchurl {
    url = "https://launchpad.net/notify-osd/precise/${finalAttrs.version}/+download/notify-osd-${finalAttrs.version}.tar.gz";
    sha256 = "0g5a7a680b05x27apz0y1ldl5csxpp152wqi42s107jymbp0s20j";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    glib
    libwnck
    libnotify
    dbus-glib
    gsettings-desktop-schemas
  ];

  configureFlags = [ "--libexecdir=$(out)/bin" ];

  preFixup = ''
    wrapProgram "$out/bin/notify-osd" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = {
    description = "Daemon that displays passive pop-up notifications";
    mainProgram = "notify-osd";
    homepage = "https://launchpad.net/notify-osd";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ bodil ];
    platforms = lib.platforms.linux;
  };
})
