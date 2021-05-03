{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, scdoc
, systemd, pango, cairo, gdk-pixbuf
, wayland, wayland-protocols
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mako";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-S3RO+/bH+h9gQJ0RvI7WLsDF6HFcPfFGCIQu/1ieIjk=";
  };

  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-protocols wrapGAppsHook ];
  buildInputs = [ systemd pango cairo gdk-pixbuf wayland ];

  mesonFlags = [
    "-Dzsh-completions=true"
    "-Dauto_features=enabled"
    "-Dsd-bus-provider=libsystemd"
  ];

  meta = with lib; {
    description = "A lightweight Wayland notification daemon";
    homepage = "https://wayland.emersion.fr/mako/";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir synthetica ma27 ];
    platforms = platforms.linux;
  };
}
