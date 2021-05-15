{ stdenv
, lib
, fetchgit
, meson
, ninja
, pkg-config
, git
, scdoc
, cairo
, fcft
, libpng
, librsvg
, libxkbcommon
, pixman
, tllist
, wayland
, wayland-protocols
, wlroots
}:

stdenv.mkDerivation rec {
  pname = "wbg";
  version = "unstable-2020-08-01";

  src = fetchgit {
    url = "https://codeberg.org/dnkl/wbg";
    rev = "1b05bd80d0f40e3ba1e977002d0653f532649269";
    sha256 = "0i1j7aqvj0vl2ww5cvffqci1kjqjn0sw6sp2j0ljblaif6qk9asc";
  };

  nativeBuildInputs = [ pkg-config meson ninja scdoc git ];
  buildInputs = [
    cairo
    fcft
    libpng
    librsvg
    libxkbcommon
    pixman
    tllist
    wayland
    wayland-protocols
    wlroots
  ];

  meta = with lib; {
    description = "Wallpaper application for Wayland compositors";
    homepage = "https://codeberg.org/dnkl/wbg";
    license = licenses.isc;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
  };
}
