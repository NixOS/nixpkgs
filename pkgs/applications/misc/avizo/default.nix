{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk3,
  glib,
  gtk-layer-shell,
  dbus,
  dbus-glib,
  librsvg,
  gobject-introspection,
  gdk-pixbuf,
  wrapGAppsHook3,
  pamixer,
  brightnessctl,
}:

stdenv.mkDerivation rec {
  pname = "avizo";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "misterdanb";
    repo = "avizo";
    rev = version;
    sha256 = "sha256-Vj8OrNlAstl0AXTeVAPdEf5JgnAmJwl9s3Jdc0ZiYQc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus
    dbus-glib
    gdk-pixbuf
    glib
    gtk-layer-shell
    gtk3
    librsvg
  ];

  postInstall = ''
    wrapProgram $out/bin/volumectl --suffix PATH : $out/bin:${lib.makeBinPath ([ pamixer ])}
    wrapProgram $out/bin/lightctl --suffix PATH : $out/bin:${lib.makeBinPath ([ brightnessctl ])}
  '';

  meta = with lib; {
    description = "A neat notification daemon for Wayland";
    homepage = "https://github.com/misterdanb/avizo";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.berbiche ];
  };
}
