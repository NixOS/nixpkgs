{ stdenv, meson, ninja
, fetchFromGitHub, wayfire
, wf-shell, pkgconfig
, libevdev, wayland
, wayland-protocols
, libxml2, gtk3, glm
}:

stdenv.mkDerivation rec {
  pname = "wcm";
  version = "5d935e0727ab976c85690669083addc9c21ee298";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = pname;
    rev = version;
    sha256 = "sha256-Nrz/Em80+C8uTUf0+Ny/WLcMKFVRKAzXaeIp3m7NsnU=";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [
    wayfire wf-shell
    libevdev wayland
    wayland-protocols
    libxml2 gtk3 glm
  ];


  meta = with stdenv.lib; {
    description = "Wayfire Config Manager";
    homepage = https://wayfire.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ ishan9299 ];
    platforms = platforms.linux;
  };
}
