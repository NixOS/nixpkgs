{ stdenv
, lib
, fetchFromGitea
, pkg-config
, meson
, ninja
, scdoc
, wayland-scanner
, fontconfig
, freetype
, pixman
, libpng
, tllist
, wayland
, wayland-protocols
, dbus
, fcft
}:

stdenv.mkDerivation rec {
  pname = "fnott";
  version = "1.4.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fnott";
    rev = version;
    sha256 = "sha256-8SKInlj54BP3Gn/DNVoLN62+Dfa8G5d/q2xGUXXdsjo=";
  };

  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    scdoc
    wayland-scanner
  ];
  buildInputs = [
    fontconfig
    freetype
    pixman
    libpng
    tllist
    wayland
    wayland-protocols
    dbus
    fcft
  ];

  meta = with lib; {
    homepage = "https://codeberg.org/dnkl/fnott";
    description = "Keyboard driven and lightweight Wayland notification daemon for wlroots-based compositors";
    license = with licenses; [ mit zlib ];
    maintainers = with maintainers; [ polykernel ];
    platforms = platforms.linux;
  };
}
