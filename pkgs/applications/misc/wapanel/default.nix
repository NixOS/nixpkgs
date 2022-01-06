{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config
, gtk3, glib, gtk-layer-shell, gdk-pixbuf, librsvg
, wayland, wayland-protocols, wayland-scanner
, libpulseaudio, xdg-utils
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "wapanel";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Firstbober";
    repo = "wapanel";
    rev = version;
    hash = "sha256-sqVH/XXFIEdB3b19eHj0gqN/hjEltxKisT/UAdMmmXA=";
    fetchSubmodules = true;
  };

  # Change to `true` once ToruNiina/toml11 is packaged
  # and remove `fetchSubmodules` in the `fetchFromGitHub` call above
  mesonFlags = [ "-Dsystem_toml11=false" ];

  nativeBuildInputs = [ meson ninja pkg-config wayland-protocols wayland-scanner wrapGAppsHook ];

  buildInputs = [ gdk-pixbuf glib.dev gtk-layer-shell gtk3 libpulseaudio librsvg wayland xdg-utils ];

  doInstallCheck = true;
  installCheckPhase = ''
    "$out"/bin/wapanel --help >/dev/null
  '';

  meta = with lib; {
    description = "Desktop-dedicated wayland bar for wayfire and other wlroots based compositors";
    maintainers = with maintainers; [ berbiche ];
    platforms = platforms.unix;
    homepage = "https://github.com/Firstbober/wapanel";
    license = licenses.mit;
    mainProgram = "wapanel";
  };
}
