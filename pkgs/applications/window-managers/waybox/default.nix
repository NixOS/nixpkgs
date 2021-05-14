{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, meson
, ninja
, libxkbcommon
, wayland
, wayland-protocols
, wlroots
, pixman
, udev
, libGL
, mesa
}:

stdenv.mkDerivation rec {
  pname = "waybox";
  version = "unstable-2021-04-07";

  src = fetchFromGitHub {
    owner = "wizbright";
    repo = pname;
    rev = "309ccd2faf08079e698104b19eff32b3a255b947";
    sha256 = "0kzss266jf1kgwnhk42vaakbmn269nphlq9xjsapp6mhccd9qz8v";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [
    libxkbcommon
    wayland
    wayland-protocols
    wlroots
    pixman
    udev
    libGL
    mesa # for libEGL
  ];

  meta = with lib; {
    homepage = "https://github.com/wizbright/waybox";
    description = "An openbox clone on Wayland";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
