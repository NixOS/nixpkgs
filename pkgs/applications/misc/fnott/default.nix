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
  version = "1.2.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fnott";
    rev = version;
    sha256 = "1qmxzpv2xy79aznzzr9fay61mzf1pdzv85ah3w3q2kl2i7pskfxb";
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
