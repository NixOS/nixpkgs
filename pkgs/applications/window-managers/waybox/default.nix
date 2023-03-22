{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, meson
, cmake
, ninja
, libxkbcommon
, wayland
, wayland-scanner
, wayland-protocols
, wlroots
, pixman
, udev
, libGL
, libxml2
, mesa
}:

stdenv.mkDerivation rec {
  pname = "waybox";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "wizbright";
    repo = pname;
    rev = version;
    hash = "sha256-G8dRa4hgev3x58uqp5To5OzF3zcPSuT3NL9MPnWf2M8=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    cmake
    ninja
    wayland-scanner
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    libxkbcommon
    libxml2
    wayland
    wayland-protocols
    wlroots
    pixman
    udev
    libGL
    mesa # for libEGL
  ];

  passthru.providedSessions = [ "waybox" ];

  meta = with lib; {
    homepage = "https://github.com/wizbright/waybox";
    description = "An openbox clone on Wayland";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
