{ stdenv
, lib
, fetchgit
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
  version = "1.1.0";

  src = fetchgit {
    url = "https://codeberg.org/dnkl/fnott.git";
    rev = version;
    sha256 = "sha256-lePd36TFQKZd+B7puUbQhLVrbybeSPjMTFWfY0B82S4=";
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
