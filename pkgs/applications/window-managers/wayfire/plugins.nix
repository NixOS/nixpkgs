{ stdenv, meson, ninja
, fetchFromGitHub, wayfire, pkgconfig
, wlroots, wayland, wayland-protocols
, cairo, glibmm, iio-sensor-proxy
, libxkbcommon, glm, librsvg
, boost, gtkmm3, udev
, libinput
}:

stdenv.mkDerivation rec {
  pname = "wayfire-plugins-extra";
  version = "b2036fc4e5935bf459b1779b89b59a73be92da9f";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire-plugins-extra";
    rev = version;
    sha256 = "sha256-u1gOd6Sp2hDgOA+gln6C+ADyzrI0HrGQFu5L0zFpZuE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [
    wayland
    wayland-protocols
    wayfire
    wlroots
    cairo
    glibmm
    iio-sensor-proxy
    libxkbcommon
    glm
    librsvg
    boost
    gtkmm3
    udev
    libinput
  ];

  mesonFlags = [
    "-Denable_nk=true"
    "-Denable_dbus=true"
    "-Denable_windecor=true"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "3D wayland compositor";
    homepage    = "https://wayfire.org/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ishan9299 ];
  };
}
