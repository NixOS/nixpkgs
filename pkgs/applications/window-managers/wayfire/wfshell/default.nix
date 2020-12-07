{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, wayland, wayland-protocols
, gtkmm3, wayfire, alsaLib
, gtk-layer-shell, librsvg
, libpulseaudio, glm, wf-config
}:

stdenv.mkDerivation rec {
  pname = "wf-shell";
  version = "3fed0524897f297bc4e7c49049c6b4221a2ff417";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ci66TOTyWZZ14VPJz3pvi+mI9EtCPMveDm5NS97l+Y4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [
    alsaLib glm gtkmm3
    gtk-layer-shell
    libpulseaudio
    wayland librsvg
    wayland-protocols
    wayfire wf-config
  ];

  mesonFlags = [
    "-Dpulse=enabled"
    "-Dwayland-logout=true"
  ];

  meta = with stdenv.lib; {
    description = "A GTK3-based panel for wayfire";
    homepage = https://wayfire.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ ishan ];
    platforms = platforms.linux;
  };
}
