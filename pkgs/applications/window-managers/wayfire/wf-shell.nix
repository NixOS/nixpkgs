{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland-scanner
, wayfire
, wf-config
, alsa-lib
, gtkmm3
, gtk-layer-shell
, pulseaudio
}:

stdenv.mkDerivation rec {
  pname = "wf-shell";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-iQUBuNjbZuf51A69RC6NsMHFZCFRv+d9XZ0HtP6OpOA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayfire
    wf-config
    alsa-lib
    gtkmm3
    gtk-layer-shell
    pulseaudio
  ];

  mesonFlags = [ "--sysconfdir /etc" ];

  meta = with lib; {
    homepage = "https://github.com/WayfireWM/wf-shell";
    description = "GTK3-based panel for Wayfire";
    license = licenses.mit;
    maintainers = with maintainers; [ qyliss wucke13 rewine ];
    platforms = platforms.unix;
  };
}
