{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland-scanner
, wayfire
, alsa-lib
, gtkmm3
, gtk-layer-shell
, pulseaudio
, libdbusmenu-gtk3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wf-shell";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wf-shell";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-J5KmUxM/mU5I1YfkfwZgbK7VxMTKKKGGvxYS5Rnbqnc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayfire
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
    maintainers = with lib.maintainers; [ wucke13 rewine ];
    platforms = lib.platforms.unix;
  };
})
