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
, libdbusmenu-gtk3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wf-shell";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wf-shell";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-K5g9DfFlqZyPHDUswx3vtzh0D9ogOQ1p87ZrqyH35vs=";
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
    libdbusmenu-gtk3
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
