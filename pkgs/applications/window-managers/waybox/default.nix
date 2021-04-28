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
  version = "unstable-2020-05-01";

  src = fetchFromGitHub {
    owner = "wizbright";
    repo = pname;
    rev = "93811898f0eea3035145f593938d49d5af759b46";
    sha256 = "IOdKOqAQD87Rs3td8NVEgMnRF6kQSuQ64UVqeVqMBSM=";
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
