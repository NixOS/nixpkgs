{ stdenv
, lib
, fetchFromGitea
, pkg-config
, meson
, ninja
, scdoc
, wayland-protocols
, tllist
, fontconfig
, freetype
, pixman
, libpng
, wayland
, wlroots
, dbus
, fcft
}:

stdenv.mkDerivation rec {
  pname = "fnott";
  version = "1.2.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fnott";
    rev = version;
    sha256 = "sha256-Ni1LwsBkh+XekHEAPxoAkE3tjgUByvpLUGpx7WC54Jw=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    scdoc
    wayland-protocols
    tllist
  ];
  buildInputs = [
    fontconfig
    freetype
    pixman
    libpng
    wayland
    wlroots
    dbus
    fcft
  ];

  meta = with lib; {
    homepage = "https://codeberg.org/dnkl/fnott";
    description = "Keyboard driven and lightweight Wayland notification daemon for wlroots-based compositors.";
    license = licenses.mit;
    maintainers = with maintainers; [ polykernel ];
    platforms = platforms.linux;
  };
}
