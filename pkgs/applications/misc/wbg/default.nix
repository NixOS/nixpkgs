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
# Optional dependencies
, libpng
, libjpeg
}:

let
  # Courtesy of sternenseemann and FRidh, commit c9a7fdfcfb420be8e0179214d0d91a34f5974c54
  mesonFeatureFlag = opt: b: "-D${opt}=${if b then "enabled" else "disabled"}";
in

stdenv.mkDerivation rec {
  pname = "wbg";
  version = "1.0.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "wbg";
    rev = version;
    sha256 = "sha256-PKEOWRcSAB4Uv5TfameQIEZh6s6xCGdyoZ13etL1TKA=";
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
    ++ lib.optional enableJPEG libjpeg;

  mesonBuildType = "release";

  mesonFlags = [
    (mesonFeatureFlag "png" enablePNG)
    (mesonFeatureFlag "jpeg" enableJPEG)
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
