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

stdenv.mkDerivation (finalAttrs: {
  pname = "wf-shell";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wf-shell";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-iQUBuNjbZuf51A69RC6NsMHFZCFRv+d9XZ0HtP6OpOA=";
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

  meta = {
    homepage = "https://github.com/WayfireWM/wf-shell";
    description = "GTK3-based panel for Wayfire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qyliss wucke13 rewine ];
    platforms = lib.platforms.unix;
  };
})
