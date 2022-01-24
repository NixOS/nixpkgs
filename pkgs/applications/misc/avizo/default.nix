{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, vala
, gtk3, glib, gtk-layer-shell
, dbus, dbus-glib, librsvg
, gobject-introspection, gdk-pixbuf, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "avizo";
  # Note: remove the 'use-sysconfig' patch on the next update
  version = "1.1";

  src = fetchFromGitHub {
    owner = "misterdanb";
    repo = "avizo";
    rev = version;
    sha256 = "sha256-0BJodJ6WaHhuSph2D1AC+DMafctgiSCyaZ8MFn89AA8=";
  };

  nativeBuildInputs = [ meson ninja pkg-config vala gobject-introspection wrapGAppsHook ];

  buildInputs = [ dbus dbus-glib gdk-pixbuf glib gtk-layer-shell gtk3 librsvg ];

  patches = [
    # Remove on next update
    # See https://github.com/misterdanb/avizo/pull/30
    ./use-sysconfdir-instead-of-etc.patch
  ];

  postInstall = ''
    substituteInPlace "$out"/bin/volumectl \
      --replace 'avizo-client' "$out/bin/avizo-client"
    substituteInPlace "$out"/bin/lightctl \
      --replace 'avizo-client' "$out/bin/avizo-client"
  '';

  meta = with lib; {
    description = "A neat notification daemon for Wayland";
    homepage = "https://github.com/misterdanb/avizo";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.berbiche ];
  };
}
