{ stdenv
, lib
, fetchFromGitea
, pkg-config
, meson
, ninja
, wayland-scanner
, wayland
, pixman
, wayland-protocols
, libxkbcommon
, scdoc
, tllist
, fcft
, enableCairo ? true
, enablePNG ? true
, enableSVG ? true
# Optional dependencies
, cairo
, librsvg
, libpng
}:

let
  # Courtesy of sternenseemann and FRidh, commit c9a7fdfcfb420be8e0179214d0d91a34f5974c54
  mesonFeatureFlag = opt: b: "-D${opt}=${if b then "enabled" else "disabled"}";
in

stdenv.mkDerivation rec {
  pname = "fuzzel";
  version = "1.6.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fuzzel";
    rev = version;
    sha256 = "sha256-JW5sAlTprSRIdFbmSaUreGtNccERgQMGEW+WCSscYQk=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    meson
    ninja
    scdoc
  ];

  buildInputs = [
    wayland
    pixman
    wayland-protocols
    libxkbcommon
    tllist
    fcft
  ] ++ lib.optional enableCairo cairo
    ++ lib.optional enablePNG libpng
    ++ lib.optional enableSVG librsvg;

  mesonBuildType = "release";

  mesonFlags = [
    (mesonFeatureFlag "enable-cairo" enableCairo)
    (mesonFeatureFlag "enable-png" enablePNG)
    (mesonFeatureFlag "enable-svg" enableSVG)
  ];

  meta = with lib; {
    description = "Wayland-native application launcher, similar to rofi’s drun mode";
    homepage = "https://codeberg.org/dnkl/fuzzel";
    license = licenses.mit;
    maintainers = with maintainers; [ fionera polykernel ];
    platforms = with platforms; linux;
    changelog = "https://codeberg.org/dnkl/fuzzel/releases/tag/${version}";
  };
}
