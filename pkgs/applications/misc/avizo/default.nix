{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, vala
, gtk3, glib, gtk-layer-shell
, dbus, dbus-glib, librsvg
, gobject-introspection, gdk-pixbuf, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "avizo";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "misterdanb";
    repo = "avizo";
    rev = version;
    sha256 = "sha256-ainU4nXWFp1udVujPHZUeWIfJE4RrjU1hn9J17UuuzU=";
  };

  nativeBuildInputs = [ meson ninja pkg-config vala gobject-introspection wrapGAppsHook ];

  buildInputs = [ dbus dbus-glib gdk-pixbuf glib gtk-layer-shell gtk3 librsvg ];

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
