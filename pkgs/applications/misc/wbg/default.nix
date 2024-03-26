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
, enableWebp ? true
# Optional dependencies
, libpng
, libjpeg
, libwebp
}:

stdenv.mkDerivation rec {
  pname = "wbg";
  version = "1.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "wbg";
    rev = version;
    sha256 = "sha256-JJIIqSc0qHgjtpGKai8p6vihXg16unsO7vW91pioAmc=";
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
    ++ lib.optional enableJPEG libjpeg
    ++ lib.optional enableWebp libwebp;

  mesonBuildType = "release";

  mesonFlags = [
    (lib.mesonEnable "png" enablePNG)
    (lib.mesonEnable "jpeg" enableJPEG)
    (lib.mesonEnable "webp" enableWebp)
  ];

  meta = with lib; {
    description = "Wallpaper application for Wayland compositors";
    homepage = "https://codeberg.org/dnkl/wbg";
    changelog = "https://codeberg.org/dnkl/wbg/releases/tag/${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
    mainProgram = "wbg";
  };
}
