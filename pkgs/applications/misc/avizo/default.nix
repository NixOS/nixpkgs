{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, vala
, gtk3, glib, gtk-layer-shell
, dbus, dbus-glib, librsvg
, gobject-introspection, gdk-pixbuf, wrapGAppsHook
}:

stdenv.mkDerivation {
  pname = "avizo";
  version = "unstable-2021-07-21";

  src = fetchFromGitHub {
    owner = "misterdanb";
    repo = "avizo";
    rev = "7b3874e5ee25c80800b3c61c8ea30612aaa6e8d1";
    sha256 = "sha256-ixAdiAH22Nh19uK5GoAXtAZJeAfCGSWTcGbrvCczWYc=";
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
