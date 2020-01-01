{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkgconfig
, cairo
, glm
, libdrm
, libevdev
, libexecinfo
, libinput
, libjpeg
, libnotify
, libxkbcommon
, wayland
, wayland-protocols
, wf-config
, wlroots
}:

stdenv.mkDerivation rec {
  pname = "wayfire";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = pname;
    rev = version;
    sha256 = "01rfkb7m1b4d0a9ph9c9jzaa7q6xa91i2ygd3xcnkz35b35qcxn2";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    cairo
    glm
    libdrm
    libexecinfo
    libinput
    libjpeg
    libnotify.dev
    libxkbcommon
    wayland
    wayland-protocols
    wf-config
    wlroots
  ];

  meta = with stdenv.lib; {
    description = "3D wayland compositor";
    homepage = "https://wayfire.org/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Thra11 wucke13 ];
  };
}
