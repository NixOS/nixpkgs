{ stdenv
, lib
, fetchFromGitea
, pkg-config
, meson
, ninja
, pixman
, tllist
, wayland
, wayland-scanner
, wayland-protocols
, enablePNG ? true
, enableJPEG ? true
<<<<<<< HEAD
, enableWebp ? true
# Optional dependencies
, libpng
, libjpeg
, libwebp
=======
# Optional dependencies
, libpng
, libjpeg
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "wbg";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "wbg";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-JJIIqSc0qHgjtpGKai8p6vihXg16unsO7vW91pioAmc=";
=======
    sha256 = "sha256-PKEOWRcSAB4Uv5TfameQIEZh6s6xCGdyoZ13etL1TKA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wayland-scanner
  ];

  buildInputs = [
    pixman
    tllist
    wayland
    wayland-protocols
  ] ++ lib.optional enablePNG libpng
<<<<<<< HEAD
    ++ lib.optional enableJPEG libjpeg
    ++ lib.optional enableWebp libwebp;
=======
    ++ lib.optional enableJPEG libjpeg;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  mesonBuildType = "release";

  mesonFlags = [
    (lib.mesonEnable "png" enablePNG)
    (lib.mesonEnable "jpeg" enableJPEG)
<<<<<<< HEAD
    (lib.mesonEnable "webp" enableWebp)
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Wallpaper application for Wayland compositors";
    homepage = "https://codeberg.org/dnkl/wbg";
    changelog = "https://codeberg.org/dnkl/wbg/releases/tag/${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
  };
}
