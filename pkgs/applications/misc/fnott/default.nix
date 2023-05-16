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
<<<<<<< HEAD
  version = "1.4.1";
=======
  version = "1.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fnott";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-8SKInlj54BP3Gn/DNVoLN62+Dfa8G5d/q2xGUXXdsjo=";
=======
    sha256 = "sha256-cJ7XmnC4x8lhZ+JRqobeQxTTps4Oz95zYdlFtr3KC1A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
