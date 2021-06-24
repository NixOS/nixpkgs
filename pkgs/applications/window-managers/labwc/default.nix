{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, meson
, ninja
, cairo
, glib
, libinput
, libxml2
, pango
, wayland
, wayland-protocols
, wlroots
, libxcb
, libxkbcommon
, xwayland
, libdrm
, scdoc
}:

stdenv.mkDerivation rec {
  pname = "labwc";
  version = "unstable-2021-03-15";

  src = fetchFromGitHub {
    owner = "johanmalm";
    repo = pname;
    rev = "fddeb74527e5b860d9c1a91a237d390041c758b6";
    sha256 = "0rhniv5j4bypqxxj0nbpa3hclmn8znal9rldv0mrgbizn3wsbs54";
  };

  nativeBuildInputs = [ pkg-config meson ninja scdoc ];
  buildInputs = [
    cairo
    glib
    libinput
    libxml2
    pango
    wayland
    wayland-protocols
    wlroots
    libxcb
    libxkbcommon
    xwayland
    libdrm
  ];

  mesonFlags = [ "-Dxwayland=enabled" ];

  meta = with lib; {
    homepage = "https://github.com/johanmalm/labwc";
    description = "Openbox alternative for Wayland";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
